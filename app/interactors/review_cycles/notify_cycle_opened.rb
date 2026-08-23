module ReviewCycles
  class NotifyCycleOpened
    include Interactor

    def call
      CycleOpenedNotifierJob.perform_later(context.review_cycle)
    end
  end
end
