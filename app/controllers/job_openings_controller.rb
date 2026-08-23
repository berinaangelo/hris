# Company tab (Recruitment / Job Openings) — see
# kos/projects/hris/features/recruitment-ats/PLAN.md. Plain
# dedicated pages, matching CertificationsController's shipped
# convention, not the "drawer" the kos UI decision doc describes (no
# real drawer component exists anywhere in this app to reuse).
class JobOpeningsController < ApplicationController
  def index
    authorize JobOpening
    @job_openings = policy_scope(JobOpening).order(created_at: :desc)
  end

  def show
    @job_opening = policy_scope(JobOpening).find(params[:id])
    authorize @job_opening
    @candidates_by_stage = @job_opening.job_candidates.includes(:hired_employee).group_by(&:stage)
  end

  def new
    authorize JobOpening
    @job_opening = JobOpening.new
  end

  def create
    authorize JobOpening
    @job_opening = current_employee.company.job_openings.new(job_opening_params)

    if @job_opening.save
      redirect_to job_opening_path(@job_opening), notice: "Job opening created."
    else
      flash.now[:alert] = @job_opening.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @job_opening = policy_scope(JobOpening).find(params[:id])
    authorize @job_opening
  end

  def update
    @job_opening = policy_scope(JobOpening).find(params[:id])
    authorize @job_opening

    if @job_opening.update(job_opening_params)
      redirect_to job_opening_path(@job_opening), notice: "Job opening updated."
    else
      flash.now[:alert] = @job_opening.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def job_opening_params
    params.require(:job_opening).permit(:title, :description, :status)
  end
end
