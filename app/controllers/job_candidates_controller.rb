# Stage changes (per-card <select onchange="submit()">, never
# drag-and-drop) and the Hire handoff — see
# kos/decisions/ui/job-opening-detail-kanban-stage-columns.md and
# kos/decisions/ui/hired-handoff-review-and-edit-drawer.md. The Hire
# form is folded into JobOpeningsController#show as a per-candidate
# drawer (no standalone new_hire page) — see that controller's
# @reopen_candidate_id.
class JobCandidatesController < ApplicationController
  def update
    candidate = JobCandidate.find(params[:id])
    authorize candidate, :update?

    if candidate.update(job_candidate_params)
      redirect_to job_opening_path(candidate.job_opening), notice: "Moved #{candidate.full_name} to #{candidate.stage.humanize}."
    else
      redirect_to job_opening_path(candidate.job_opening), alert: candidate.errors.full_messages.to_sentence
    end
  end

  def hire
    candidate = JobCandidate.find(params[:id])
    authorize candidate, :hire?

    first_name, *rest = candidate.full_name.split(" ")
    employee_params = hire_params.merge(
      first_name: first_name, last_name: rest.join(" "),
      work_email: candidate.email, personal_email: candidate.email
    )

    ActiveRecord::Base.transaction do
      JobCandidates::MarkHired.call!(
        job_candidate: candidate, employee_params: employee_params, company: current_employee.company
      )
    end
    redirect_to job_opening_path(candidate.job_opening), notice: "#{candidate.full_name} hired — employee record created."
  rescue Interactor::Failure => e
    redirect_to job_opening_path(candidate.job_opening, reopen_hire: candidate.id), alert: e.context.message
  end

  private

  def job_candidate_params
    params.require(:job_candidate).permit(:stage)
  end

  def hire_params
    params.require(:employee).permit(:job_title, :department, :manager_id, :start_date, :employment_type, :password)
  end
end
