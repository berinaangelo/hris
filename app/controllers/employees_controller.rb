class EmployeesController < ApplicationController
  def index
    authorize Employee
    @employees = policy_scope(Employee).includes(:manager).order(:last_name)
    @employees = @employees.where(department: params[:department]) if params[:department].present?
    @employees = @employees.where("first_name LIKE :q OR last_name LIKE :q", q: "%#{params[:q]}%") if params[:q].present?
    @departments = policy_scope(Employee).distinct.pluck(:department).compact.sort
  end

  def new
    authorize Employee
    @employee = Employee.new
    @managers = policy_scope(Employee).where(role: [:manager, :admin])
  end

  def create
    authorize Employee

    result = Employees::Onboard.call(employee_params: employee_params, company: current_employee.company)

    if result.success?
      redirect_to employee_path(result.employee), notice: "#{result.employee.full_name} added."
    else
      flash.now[:alert] = result.message
      @employee = Employee.new(employee_params)
      @managers = policy_scope(Employee).where(role: [:manager, :admin])
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @employee = policy_scope(Employee).find(params[:id])
    authorize @employee
    @onboarding_items = @employee.checklist_items.onboarding.order(:position)
    @offboarding_items = @employee.checklist_items.offboarding.order(:position)
  end

  def update
    @employee = policy_scope(Employee).find(params[:id])
    authorize @employee

    if @employee.update(employee_update_params)
      redirect_to employee_path(@employee), notice: "Saved."
    else
      flash.now[:alert] = @employee.errors.full_messages.to_sentence
      @onboarding_items = @employee.checklist_items.onboarding.order(:position)
      @offboarding_items = @employee.checklist_items.offboarding.order(:position)
      render :show, status: :unprocessable_entity
    end
  end

  def schedule_offboarding
    @employee = policy_scope(Employee).find(params[:id])
    authorize @employee, :schedule_offboarding?

    result = Employees::ScheduleOffboarding.call(
      employee: @employee,
      last_working_day: params[:last_working_day],
      offboarding_reason: params[:offboarding_reason],
      rehire_eligible: params[:rehire_eligible],
      offboarding_notes: params[:offboarding_notes]
    )

    if result.success?
      redirect_to employee_path(@employee), notice: "Offboarding scheduled."
    else
      redirect_to employee_path(@employee), alert: result.message
    end
  end

  def mark_offboarded
    @employee = policy_scope(Employee).find(params[:id])
    authorize @employee, :mark_offboarded?

    result = Employees::MarkOffboarded.call(employee: @employee)

    if result.success?
      redirect_to employee_path(@employee), notice: "#{@employee.full_name} marked offboarded."
    else
      redirect_to employee_path(@employee), alert: result.message
    end
  end

  private

  def employee_params
    params.require(:employee).permit(
      :first_name, :last_name, :personal_email, :work_email, :password,
      :job_title, :department, :manager_id, :start_date, :employment_type
    )
  end

  def employee_update_params
    params.require(:employee).permit(
      :first_name, :last_name, :personal_email, :work_email,
      :mobile_number, :home_address, :birthdate,
      :emergency_contact_name, :emergency_contact_phone,
      :job_title, :department, :manager_id, :start_date, :employment_type
    )
  end
end
