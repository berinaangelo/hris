module ReviewCycles
  # Persists in-progress scoring without requiring every KPI to be
  # scored yet — the manager can save a partial draft and come back
  # later. Publishing (see MarkFullyScored) is what enforces
  # completeness. Single-purpose, not an organizer — mirrors
  # Certifications::UpdateCertification.
  class SaveDraftScores
    include Interactor

    def call
      review_cycle = context.review_cycle

      context.kpi_scores_params.each do |kpi_entry_id, raw_attrs|
        kpi_entry = review_cycle.kpi_entries.find_by(id: kpi_entry_id)
        next unless kpi_entry

        attrs = raw_attrs.with_indifferent_access
        kpi_entry.actual = attrs[:actual] if attrs.key?(:actual)
        kpi_entry.score = attrs[:score].presence if attrs.key?(:score)
        kpi_entry.comment = attrs[:comment] if attrs.key?(:comment)

        unless kpi_entry.save
          context.fail!(message: kpi_entry.errors.full_messages.to_sentence)
          return
        end
      end

      review_cycle.manager_comment = context.manager_comment if context.manager_comment
      review_cycle.status = :awaiting_scoring if review_cycle.in_progress?

      unless review_cycle.save
        context.fail!(message: review_cycle.errors.full_messages.to_sentence)
      end
    end
  end
end
