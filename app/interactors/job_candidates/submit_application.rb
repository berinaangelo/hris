module JobCandidates
  class SubmitApplication
    include Interactor

    def call
      unless context.consent
        context.fail!(message: "Please confirm your consent to data processing to continue.")
        return
      end

      candidate = context.job_opening.job_candidates.new(context.candidate_params)
      candidate.applied_at = Time.current
      candidate.consent_given_at = Time.current

      if candidate.save
        context.candidate = candidate
        notify_admins(candidate)
      else
        context.fail!(message: candidate.errors.full_messages.to_sentence)
      end
    end

    private

    def notify_admins(candidate)
      candidate.job_opening.company.employees.admin.find_each do |admin|
        NewCandidateNotifierJob.perform_later(candidate, admin)
      end
    end
  end
end
