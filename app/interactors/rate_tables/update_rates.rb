module RateTables
  # Edits replace the current table outright — no effective-dated
  # version history, per kos/decisions/schema/payroll-v2-schema.md.
  #
  # brackets/fields arrive as structured params (not JSON strings) from
  # the landing-cards-and-drawer editor — see
  # kos/decisions/ui/rate-tables-landing-cards-edit-drawer.md. A blank
  # bracket row (an untouched extra row left over from "+ Add bracket")
  # is dropped rather than saved.
  class UpdateRates
    include Interactor

    def call
      rate_table = context.rate_table

      rate_table.assign_attributes(
        effective_date: context.effective_date,
        brackets: normalized_brackets,
        fields: normalized_fields,
        updated_by: context.updated_by
      )

      if rate_table.save
        context.rate_table = rate_table
      else
        context.fail!(message: rate_table.errors.full_messages.to_sentence)
      end
    end

    private

    def normalized_brackets
      Array(context.brackets).filter_map { |row| normalize_row(row) }
    end

    def normalize_row(row)
      normalized = row.to_h.transform_values { |value| value.presence && value.to_f }
      return nil if normalized.values.all?(&:nil?)

      normalized
    end

    def normalized_fields
      context.fields.to_h.filter_map { |key, value| [ key, value.to_f ] if value.present? }.to_h
    end
  end
end
