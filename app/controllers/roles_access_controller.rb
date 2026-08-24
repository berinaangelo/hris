class RolesAccessController < ApplicationController
  def index
    authorize Employee, :index?
    @employees = policy_scope(Employee).order(:last_name)
    @employees = @employees.where(role: params[:role]) if params[:role].present?
    @employees = @employees.where("first_name LIKE :q OR last_name LIKE :q", q: "%#{params[:q]}%") if params[:q].present?
  end

  # No separate #edit — "Change" opens a right-side drawer on #index
  # instead (10th reuse of the drawer mechanic), see
  # kos/decisions/ui/roles-access-reference-plus-assignment-drawer.md.
  def update
    @employee = policy_scope(Employee).find(params[:id])
    authorize @employee, :assign_role?

    result = Employees::AssignRole.call(employee: @employee, role: params[:employee][:role])

    if result.success?
      redirect_to roles_access_index_path, notice: "#{@employee.full_name}'s access level updated."
    else
      flash.now[:alert] = result.message
      @employees = policy_scope(Employee).order(:last_name)
      @reopen_employee_id = @employee.id
      render :index, status: :unprocessable_entity
    end
  end
end
