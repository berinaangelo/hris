module ReviewCycles
  class CreateKpiEntries
    include Interactor

    def call
      # 0 is the deliberate "shell cycle" case (Company Reviews' bulk
      # department/company open — KPIs get filled in later from Team
      # Reviews' attach-KPIs flow). Anything submitted for real must be a
      # proper 3-5 set, matching the range shown in the UI's own add/remove
      # controls (see dynamic_rows_controller.js) — no partial 1-2 sets.
      count = context.kpi_entries_params.size
      unless count.zero? || count.between?(3, 5)
        context.fail!(message: "Add between 3 and 5 KPIs, or leave this cycle without KPIs for now.")
        return
      end

      context.kpi_entries_params.each_with_index do |kpi_entry_params, index|
        kpi_entry = context.review_cycle.kpi_entries.build(
          kpi_name: kpi_entry_params[:kpi_name],
          target: kpi_entry_params[:target],
          position: index + 1
        )

        unless kpi_entry.save
          context.fail!(message: kpi_entry.errors.full_messages.to_sentence)
          return
        end
      end
    end

    def rollback
      context.review_cycle&.kpi_entries&.destroy_all
    end
  end
end
