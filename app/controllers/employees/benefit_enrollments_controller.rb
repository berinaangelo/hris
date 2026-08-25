module Employees
  # Record-keeping only — see kos/projects/hris/features/benefits/PLAN.md.
  # Authorized against the parent Employee, no separate policy class,
  # mirroring employees/documents_controller.rb.
  class BenefitEnrollmentsController < ApplicationController
    def create
      @employee = policy_scope(Employee).includes(benefit_enrollments: :benefit_dependents).find(params[:employee_id])
      authorize @employee, :update?

      enrollment = @employee.benefit_enrollments.build(benefit_enrollment_params)
      if enrollment.save
        redirect_to employee_path(@employee), notice: "Benefit plan added."
      else
        flash.now[:alert] = enrollment.errors.full_messages.to_sentence
        render_benefits_show
      end
    end

    def update
      @employee = policy_scope(Employee).includes(benefit_enrollments: :benefit_dependents).find(params[:employee_id])
      authorize @employee, :update?

      # .detect on the already-loaded association, not .find(id) — the
      # latter re-queries and returns a fresh instance even when loaded,
      # which would desync it from the array employees/show.html.erb
      # iterates on a failed-validation re-render (see render_benefits_show).
      enrollment = @employee.benefit_enrollments.detect { |candidate| candidate.id == params[:id].to_i }
      raise ActiveRecord::RecordNotFound unless enrollment

      if enrollment.update(benefit_enrollment_params)
        redirect_to employee_path(@employee), notice: "Benefit plan updated."
      else
        flash.now[:alert] = enrollment.errors.full_messages.to_sentence
        render_benefits_show
      end
    end

    def destroy
      employee = policy_scope(Employee).find(params[:employee_id])
      authorize employee, :update?

      employee.benefit_enrollments.find(params[:id]).destroy
      redirect_to employee_path(employee), notice: "Benefit plan removed."
    end

    private

    # Failed create/update re-renders employees/show (rather than
    # redirecting) so the admin's just-typed values survive, matching
    # EmployeesController#update's own convention. @employee was loaded
    # with benefit_enrollments eager-loaded above, so the invalid,
    # unpersisted/unsaved enrollment this action just built is the same
    # in-memory object the re-rendered view iterates over.
    def render_benefits_show
      @onboarding_items = @employee.checklist_items.onboarding.order(:position)
      @offboarding_items = @employee.checklist_items.offboarding.order(:position)
      @shift_templates = @employee.company.shift_templates.order(:start_time)
      render "employees/show", status: :unprocessable_entity
    end

    def benefit_enrollment_params
      params.require(:benefit_enrollment).permit(
        :plan_name, :provider, :effectivity_date,
        benefit_dependents_attributes: [ :id, :name, :relationship, :_destroy ]
      )
    end
  end
end
