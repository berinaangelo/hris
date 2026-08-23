module ReviewCycles
  # Guards publish against an incomplete cycle — every KPI entry needs
  # a score before a cycle can be published. Runs after SaveDraftScores
  # so the scores just submitted are already persisted when checked.
  class MarkFullyScored
    include Interactor

    def call
      review_cycle = context.review_cycle

      if review_cycle.kpi_entries.reload.any? { |kpi_entry| kpi_entry.score.blank? }
        context.fail!(message: "Every KPI needs a score before you can publish this review.")
      end

      if review_cycle.pip? && context.outcome.blank?
        context.fail!(message: "Select an outcome before publishing a PIP.")
      end
    end
  end
end
