module Payslips
  # Admin-only, and only while the parent payslip is a draft —
  # PayslipPolicy#edit_line_items? enforces both. Exists for Void &
  # Reissue's "editable before it's finalized" reissue, not for
  # touching a finalized cutoff's locked line items.
  class LineItemsController < ApplicationController
    def create
      @payslip = load_payslip
      authorize @payslip, :edit_line_items?

      line_item = @payslip.payslip_line_items.build(line_item_params.merge(source: :manual))
      if line_item.save
        Payroll::RecomputePayslipTotals.call(payslip: @payslip)
        redirect_to payslip_path(@payslip), notice: "Line item added."
      else
        flash.now[:alert] = line_item.errors.full_messages.to_sentence
        render "payslips/show", status: :unprocessable_entity
      end
    end

    def update
      @payslip = load_payslip
      authorize @payslip, :edit_line_items?

      # .detect on the already-loaded association, not .find(id) — keeps
      # the in-memory object in sync with what the re-rendered
      # payslips/show iterates on a failed validation (see
      # Employees::BenefitEnrollmentsController#update for the same fix).
      line_item = @payslip.payslip_line_items.detect { |candidate| candidate.id == params[:id].to_i }
      raise ActiveRecord::RecordNotFound unless line_item

      if line_item.update(line_item_params)
        Payroll::RecomputePayslipTotals.call(payslip: @payslip)
        redirect_to payslip_path(@payslip), notice: "Line item updated."
      else
        flash.now[:alert] = line_item.errors.full_messages.to_sentence
        render "payslips/show", status: :unprocessable_entity
      end
    end

    def destroy
      @payslip = load_payslip
      authorize @payslip, :edit_line_items?

      @payslip.payslip_line_items.find(params[:id]).destroy
      Payroll::RecomputePayslipTotals.call(payslip: @payslip)
      redirect_to payslip_path(@payslip), notice: "Line item removed."
    end

    private

    def load_payslip
      policy_scope(Payslip)
        .includes(:payroll_run, :payslip_line_items, :previous_version, :reissued_version, :generated_by, :employee)
        .find(params[:payslip_id])
    end

    def line_item_params
      params.require(:payslip_line_item).permit(:line_type, :direction, :amount, :description)
    end
  end
end
