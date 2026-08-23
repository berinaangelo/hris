module JobCandidates
  class LinkHiredEmployee
    include Interactor

    def call
      context.job_candidate.update!(hired_employee: context.employee, stage: :hired)
    end

    def rollback
      context.job_candidate.update!(hired_employee: nil, stage: :offer)
    end
  end
end
