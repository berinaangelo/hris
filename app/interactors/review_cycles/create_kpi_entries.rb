module ReviewCycles
  class CreateKpiEntries
    include Interactor

    def call
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
