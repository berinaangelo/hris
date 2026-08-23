module Employees
  # Record-keeping only — see kos/projects/hris/features/benefits/PLAN.md.
  # Authorized against the parent Employee, no separate policy class,
  # mirroring employees/documents_controller.rb.
  class BenefitEnrollmentsController < ApplicationController
    def create
      employee = policy_scope(Employee).find(params[:employee_id])
      authorize employee, :update?

      enrollment = employee.benefit_enrollments.new(benefit_enrollment_params)
      if enrollment.save
        redirect_to employee_path(employee), notice: "Benefit plan added."
      else
        redirect_to employee_path(employee), alert: enrollment.errors.full_messages.to_sentence
      end
    end

    def update
      employee = policy_scope(Employee).find(params[:employee_id])
      authorize employee, :update?

      enrollment = employee.benefit_enrollments.find(params[:id])
      if enrollment.update(benefit_enrollment_params)
        redirect_to employee_path(employee), notice: "Benefit plan updated."
      else
        redirect_to employee_path(employee), alert: enrollment.errors.full_messages.to_sentence
      end
    end

    def destroy
      employee = policy_scope(Employee).find(params[:employee_id])
      authorize employee, :update?

      employee.benefit_enrollments.find(params[:id]).destroy
      redirect_to employee_path(employee), notice: "Benefit plan removed."
    end

    private

    def benefit_enrollment_params
      params.require(:benefit_enrollment).permit(
        :plan_name, :provider, :effectivity_date,
        benefit_dependents_attributes: [ :id, :name, :relationship, :_destroy ]
      )
    end
  end
end
