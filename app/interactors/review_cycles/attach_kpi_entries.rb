module ReviewCycles
  # Attaches KPI entries to an already-open "shell" cycle (one opened
  # with zero KPIs via a bulk company-wide/department "Start new cycle"
  # — see CompanyReviewCyclesController#create). Reuses CreateKpiEntries
  # as-is since it's already generic over context.review_cycle/
  # kpi_entries_params. NotifyCycleOpened correctly fires here since
  # this is the cycle's first 0->N KPI transition — see its own comment.
  class AttachKpiEntries
    include Interactor::Organizer

    organize ReviewCycles::CreateKpiEntries, ReviewCycles::NotifyCycleOpened
  end
end
