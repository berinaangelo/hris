module RateTables
  # Edits replace the current table outright — no effective-dated
  # version history, per kos/decisions/schema/payroll-v2-schema.md.
  class UpdateRates
    include Interactor

    def call
      rate_table = context.rate_table

      begin
        brackets = parse_json(context.brackets_json)
        fields = parse_json(context.fields_json)
      rescue JSON::ParserError
        context.fail!(message: "Brackets and fields must each be valid JSON.")
        return
      end

      rate_table.assign_attributes(
        effective_date: context.effective_date,
        brackets: brackets,
        fields: fields,
        updated_by: context.updated_by
      )

      if rate_table.save
        context.rate_table = rate_table
      else
        context.fail!(message: rate_table.errors.full_messages.to_sentence)
      end
    end

    private

    def parse_json(raw)
      return nil if raw.blank?

      JSON.parse(raw)
    end
  end
end
