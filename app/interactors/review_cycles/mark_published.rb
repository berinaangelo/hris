module ReviewCycles
  class MarkPublished
    include Interactor

    def call
      review_cycle = context.review_cycle
      return if review_cycle.published?

      review_cycle.update!(status: :published, published_at: Time.current, outcome: context.outcome.presence)
    end

    def rollback
      context.review_cycle.update!(status: :awaiting_scoring, published_at: nil, outcome: nil)
    end
  end
end
