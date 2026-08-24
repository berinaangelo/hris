module RateTables
  # A company has no RateTable rows until someone touches Rate Tables —
  # this backfills all 4 with empty placeholders so #edit/#update always
  # have a real row to work with, per
  # kos/decisions/ui/rate-tables-landing-cards-edit-drawer.md.
  class EnsureAllAgencies
    include Interactor

    def call
      company = context.company

      RateTable.agencies.each_key do |agency|
        RateTable.find_or_create_by!(company: company, agency: agency) do |rate_table|
          rate_table.effective_date = Date.current
          rate_table.brackets = []
          rate_table.fields = {}
        end
      end
    end
  end
end
