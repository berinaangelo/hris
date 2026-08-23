module Employees
  class BenefitDependentsController < ApplicationController
    def create
      employee = policy_scope(Employee).find(params[:employee_id])
      authorize employee, :update?
      enrollment = employee.benefit_enrollments.find(params[:benefit_enrollment_id])

      dependent = enrollment.benefit_dependents.new(benefit_dependent_params)

      if dependent.save
        redirect_to employee_path(employee), notice: "#{dependent.name} added as a dependent."
      else
        redirect_to employee_path(employee), alert: dependent.errors.full_messages.to_sentence
      end
    end

    def destroy
      employee = policy_scope(Employee).find(params[:employee_id])
      authorize employee, :update?
      enrollment = employee.benefit_enrollments.find(params[:benefit_enrollment_id])
      dependent = enrollment.benefit_dependents.find(params[:id])

      dependent.destroy
      redirect_to employee_path(employee), notice: "#{dependent.name} removed."
    end

    private

    def benefit_dependent_params
      params.require(:benefit_dependent).permit(:name, :relationship)
    end
  end
end
