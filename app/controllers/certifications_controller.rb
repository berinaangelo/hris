class CertificationsController < ApplicationController
  def index
    authorize Certification
    @certifications = Certifications::Filtered.call(viewer: current_employee, search: params[:q], status: params[:status])
    @needs_attention = policy_scope(Certification)
                          .where("expiry_date <= ?", Certification::EXPIRING_SOON_WINDOW.from_now.to_date)
                          .includes(:employee)
                          .sorted_by_expiry
  end

  def new
    authorize Certification
    @certification = Certification.new
    @employees = policy_scope(Employee).order(:last_name)
  end

  def create
    authorize Certification
    employee = policy_scope(Employee).find_by(id: certification_params[:employee_id])

    result = Certifications::CreateCertification.call(employee: employee, certification_params: certification_params)

    if result.success?
      redirect_to certifications_path, notice: "#{result.certification.cert_name} added for #{result.certification.employee.full_name}."
    else
      flash.now[:alert] = result.message
      @certification = Certification.new(certification_params)
      @employees = policy_scope(Employee).order(:last_name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @certification = policy_scope(Certification).find(params[:id])
    authorize @certification
    @employees = policy_scope(Employee).order(:last_name)
  end

  def update
    @certification = policy_scope(Certification).find(params[:id])
    authorize @certification
    employee = policy_scope(Employee).find_by(id: certification_params[:employee_id])

    result = Certifications::UpdateCertification.call(
      certification: @certification,
      employee: employee,
      cert_name: certification_params[:cert_name],
      expiry_date: certification_params[:expiry_date]
    )

    if result.success?
      redirect_to certifications_path, notice: "#{@certification.cert_name} updated."
    else
      flash.now[:alert] = result.message
      @employees = policy_scope(Employee).order(:last_name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @certification = policy_scope(Certification).find(params[:id])
    authorize @certification

    @certification.destroy
    redirect_to certifications_path, notice: "Certification deleted."
  end

  private

  def certification_params
    params.require(:certification).permit(:employee_id, :cert_name, :expiry_date)
  end
end
