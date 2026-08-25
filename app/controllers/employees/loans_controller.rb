module Employees
  # Record-keeping only, mirrors
  # app/controllers/employees/benefit_enrollments_controller.rb exactly:
  # authorized against the parent Employee, no separate policy class.
  class LoansController < ApplicationController
    def create
      @employee = policy_scope(Employee).includes(:loans).find(params[:employee_id])
      authorize @employee, :update?

      loan = @employee.loans.build(loan_params)
      if loan.save
        redirect_to employee_path(@employee), notice: "Loan added."
      else
        flash.now[:alert] = loan.errors.full_messages.to_sentence
        render_loans_show
      end
    end

    def update
      @employee = policy_scope(Employee).includes(:loans).find(params[:employee_id])
      authorize @employee, :update?

      # .detect on the already-loaded association, not .find(id) — see
      # Employees::BenefitEnrollmentsController#update for why.
      loan = @employee.loans.detect { |candidate| candidate.id == params[:id].to_i }
      raise ActiveRecord::RecordNotFound unless loan

      if loan.update(loan_params)
        redirect_to employee_path(@employee), notice: "Loan updated."
      else
        flash.now[:alert] = loan.errors.full_messages.to_sentence
        render_loans_show
      end
    end

    def destroy
      employee = policy_scope(Employee).find(params[:employee_id])
      authorize employee, :update?

      loan = employee.loans.find(params[:id])
      if loan.deletable?
        loan.destroy
        redirect_to employee_path(employee), notice: "Loan removed."
      else
        redirect_to employee_path(employee), alert: "Can't remove a loan that's already been deducted in a payslip."
      end
    end

    private

    def render_loans_show
      @onboarding_items = @employee.checklist_items.onboarding.order(:position)
      @offboarding_items = @employee.checklist_items.offboarding.order(:position)
      @shift_templates = @employee.company.shift_templates.order(:start_time)
      render "employees/show", status: :unprocessable_entity
    end

    def loan_params
      params.require(:loan).permit(:loan_type, :total_amount, :monthly_amortization, :remaining_installments)
    end
  end
end
