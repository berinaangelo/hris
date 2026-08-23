# Public, unauthenticated job-application form — reached via a job
# opening's slug link, not a login-gated HRIS page. The split-panel
# layout reuses the login page's own `.auth-split` classes, confirmed
# the only other unauthenticated page in this app. Never calls
# authorize/policy_scope — there's no current_employee to authorize
# against, and no precedent anywhere in this app for teaching Pundit
# about a nil user. See kos/decisions/ui/job-application-form-split-panel.md
# and kos/projects/hris/features/recruitment-ats/PLAN.md.
class CareersController < ApplicationController
  skip_before_action :require_employee

  def show
    @job_opening = JobOpening.open.find_by!(slug: params[:slug])
    @candidate = JobCandidate.new
  end

  def create
    @job_opening = JobOpening.open.find_by!(slug: params[:slug])

    result = JobCandidates::SubmitApplication.call(
      job_opening: @job_opening, candidate_params: candidate_params, consent: params[:job_candidate][:consent] == "1"
    )

    if result.success?
      redirect_to careers_path(@job_opening.slug), notice: "Thanks — we've received your application."
    else
      @candidate = JobCandidate.new(candidate_params)
      flash.now[:alert] = result.message
      render :show, status: :unprocessable_entity
    end
  end

  private

  def candidate_params
    params.require(:job_candidate).permit(:full_name, :email, :phone, :note, :resume)
  end
end
