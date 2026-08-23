module ReviewCycles
  # No-ops for a KPI-less "shell" cycle (see ReviewCycles::OpenCycle's
  # bulk company-wide/department callers and ReviewCycles::AttachKpiEntries)
  # — the employee is only notified once their cycle actually has
  # content, whichever step puts the first KPI entry on it.
  class NotifyCycleOpened
    include Interactor

    def call
      return if context.review_cycle.kpi_entries.empty?

      CycleOpenedNotifierJob.perform_later(context.review_cycle)
    end
  end
end
