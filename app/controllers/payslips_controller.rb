class PayslipsController < ApplicationController
  def index
    authorize Payslip
    # Always "mine," regardless of role — an admin's broadened
    # policy_scope (any company payslip, for #show's drill-in) would
    # otherwise leak into this self-service list.
    @payslips = current_employee.payslips.finalized.includes(:payroll_run, :payslip_line_items).order(created_at: :desc)
    @pinned_payslip = @payslips.find { |p| p.id == params[:pinned_id].to_i } if params[:pinned_id].present?
    @pinned_payslip ||= @payslips.first
  end

  def show
    @payslip = policy_scope(Payslip)
                 .includes(:payroll_run, :payslip_line_items, :previous_version, :reissued_version, :generated_by, :employee)
                 .find(params[:id])
    authorize @payslip

    if @payslip.employee == current_employee
      mark_viewed
    else
      # An admin drilling into someone else's payslip (from Payroll) is
      # still on the PayslipsController#show action, which the nav
      # would otherwise resolve to "Me" — see navigation_presenter.rb's
      # section_override.
      @nav_section_override = :company
    end
  end

  def void_and_reissue
    @payslip = policy_scope(Payslip).find(params[:id])
    authorize @payslip, :void_and_reissue?

    result = Payroll::VoidAndReissuePayslip.call(payslip: @payslip, void_reason: params[:void_reason])

    if result.success?
      redirect_to payslip_path(result.new_payslip), notice: "Payslip voided — reissue is a draft you can edit before finalizing."
    else
      redirect_to payslip_path(@payslip), alert: result.message
    end
  end

  def finalize
    @payslip = policy_scope(Payslip).find(params[:id])
    authorize @payslip, :finalize?

    result = Payroll::FinalizePayslip.call(payslip: @payslip, finalized_by: current_employee)

    if result.success?
      redirect_to payslip_path(@payslip), notice: "Payslip finalized."
    else
      redirect_to payslip_path(@payslip), alert: result.message
    end
  end

  private

  def mark_viewed
    @payslip.update_column(:viewed_at, Time.current) if @payslip.viewed_at.nil?
  end
end
