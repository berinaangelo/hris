class CertificationsController < ApplicationController
  def index
    authorize Certification
    load_index_collections
    @certification = Certification.new
  end

  def create
    authorize Certification
    employee = policy_scope(Employee).find_by(id: certification_params[:employee_id])

    result = Certifications::CreateCertification.call(employee: employee, certification_params: certification_params)
    # The interactor only builds+validates a certification once an
    # employee was found — a blank employee_id fails before that, so
    # validate here too (belongs_to :employee is required by default)
    # to get real errors, not just a flash message, so the Add drawer
    # actually reopens on this path.
    @certification = result.certification || Certification.new(certification_params).tap(&:validate)

    if result.success?
      redirect_to certifications_path, notice: "#{result.certification.cert_name} added for #{result.certification.employee.full_name}."
    else
      flash.now[:alert] = result.message
      render_index_with_reopen
    end
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
      render_index_with_reopen
    end
  end

  def destroy
    @certification = policy_scope(Certification).find(params[:id])
    authorize @certification

    @certification.destroy
    redirect_to certifications_path, notice: "Certification deleted."
  end

  private

  def load_index_collections
    all_certifications = policy_scope(Certification)
    @total_count = all_certifications.count
    @expired_count = all_certifications.expired.count
    @expiring_soon_count = all_certifications.expiring_soon.count
    @needs_attention = all_certifications.where("expiry_date <= ?", Certification::EXPIRING_SOON_WINDOW.from_now.to_date)
                          .includes(:employee)
                          .sorted_by_expiry
    @certifications = Certifications::Filtered.call(viewer: current_employee, search: params[:q], status: params[:status])
    @employees = policy_scope(Employee).order(:last_name)
  end

  # Re-renders index (rather than redirecting) so a failed create/update
  # keeps the admin's just-typed values and inline errors visible in the
  # right drawer instead of silently dropping them — same convention as
  # Employees::BenefitEnrollmentsController#render_benefits_show.
  def render_index_with_reopen
    load_index_collections

    if @certification.persisted?
      # Certifications::Filtered returns a fresh relation each call, so
      # without this swap the row would show the old persisted values
      # instead of the just-typed invalid ones — same reasoning as
      # Employees::LoansController's .detect-not-.find comment, adapted
      # for a query-object result rather than a loaded association.
      @certifications = @certifications.map { |certification| certification.id == @certification.id ? @certification : certification }
    end

    render :index, status: :unprocessable_entity
  end

  def certification_params
    params.require(:certification).permit(:employee_id, :cert_name, :expiry_date)
  end
end
