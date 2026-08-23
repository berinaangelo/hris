module ReviewCycles
  class NotifyCyclePublished
    include Interactor

    def call
      CyclePublishedNotifierJob.perform_later(context.review_cycle)
    end
  end
end
