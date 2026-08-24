module Payroll
  # Looks up the employee-share statutory deduction for one agency's
  # RateTable against a gross amount. Deliberately data-driven, not a
  # formula per agency — see
  # kos/decisions/statutory-deductions-as-editable-data-not-code.md.
  #
  # Only the employee share is computed/recorded — employer share isn't
  # a payslip line item, matching Reports::StatutoryContributionsSummary
  # reading PayslipLineItem by line_type alone.
  class StatutoryDeductionCalculator
    def self.call(rate_table:, gross:)
      new(rate_table, gross).call
    end

    def initialize(rate_table, gross)
      @rate_table = rate_table
      @gross = gross
    end

    def call
      return 0 if @rate_table.brackets.blank? && @rate_table.fields.blank?
      return flat_rate_deduction if @rate_table.brackets.blank?

      bracket = matching_bracket
      return 0 unless bracket

      @rate_table.bir? ? excess_over_deduction(bracket) : bracket["employee_share"].to_f
    end

    private

    def matching_bracket
      @rate_table.brackets.find do |bracket|
        min = bracket["min"].to_f
        max = bracket["max"]
        @gross >= min && (max.nil? ? true : @gross <= max.to_f)
      end
    end

    # BIR-style graduated tax: base amount for the bracket, plus a
    # percentage of whatever's over the bracket's floor.
    def excess_over_deduction(bracket)
      base_amount = bracket["base_amount"].to_f
      percent_over_excess = bracket["percent_over_excess"].to_f
      min = bracket["min"].to_f

      base_amount + (percent_over_excess / 100.0 * (@gross - min))
    end

    # PhilHealth-style: no brackets, a flat percentage of gross clamped
    # to a floor/ceiling.
    def flat_rate_deduction
      fields = @rate_table.fields || {}
      percent = fields["employee_share_percent"].to_f
      floor = fields["income_floor"]&.to_f
      ceiling = fields["income_ceiling"]&.to_f

      base = @gross
      base = floor if floor && base < floor
      base = ceiling if ceiling && base > ceiling

      base * (percent / 100.0)
    end
  end
end
