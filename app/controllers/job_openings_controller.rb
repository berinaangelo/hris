# Company tab (Recruitment / Job Openings) — see
# kos/projects/hris/features/recruitment-ats/PLAN.md. Add/Edit fold into
# index/show as right-side drawers (no standalone new/edit pages), same
# mechanic as CertificationsController and RolesAccessController — see
# kos/decisions/ui/job-opening-form-right-side-drawer.md.
class JobOpeningsController < ApplicationController
  def index
    authorize JobOpening
    @job_openings = policy_scope(JobOpening).includes(job_candidates: :hired_employee).order(created_at: :desc)
    @job_opening = JobOpening.new
  end

  def show
    @job_opening = policy_scope(JobOpening).find(params[:id])
    authorize @job_opening
    @candidates_by_stage = @job_opening.job_candidates.includes(:hired_employee).group_by(&:stage)
    # Needed for the folded Hire drawer — see
    # kos/decisions/ui/hired-handoff-review-and-edit-drawer.md.
    @managers = policy_scope(Employee).where(role: [ :manager, :admin ])
    # Set by JobCandidatesController#hire's failure redirect so the one
    # candidate's Mark Hired drawer reopens with the error visible.
    @reopen_candidate_id = params[:reopen_hire].presence&.to_i
  end

  def create
    authorize JobOpening
    @job_opening = current_employee.company.job_openings.new(job_opening_params)

    if @job_opening.save
      redirect_to job_opening_path(@job_opening), notice: "Job opening created."
    else
      flash.now[:alert] = @job_opening.errors.full_messages.to_sentence
      @job_openings = policy_scope(JobOpening).includes(job_candidates: :hired_employee).order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @job_opening = policy_scope(JobOpening).find(params[:id])
    authorize @job_opening

    if @job_opening.update(job_opening_params)
      redirect_to job_opening_path(@job_opening), notice: "Job opening updated."
    else
      flash.now[:alert] = @job_opening.errors.full_messages.to_sentence
      @candidates_by_stage = @job_opening.job_candidates.includes(:hired_employee).group_by(&:stage)
      @managers = policy_scope(Employee).where(role: [ :manager, :admin ])
      render :show, status: :unprocessable_entity
    end
  end

  private

  def job_opening_params
    params.require(:job_opening).permit(:title, :description, :status)
  end
end
