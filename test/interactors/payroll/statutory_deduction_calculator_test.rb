require "test_helper"

module Payroll
  class StatutoryDeductionCalculatorTest < ActiveSupport::TestCase
    test "SSS: bracket-based, returns the matching bracket's employee_share" do
      deduction = Payroll::StatutoryDeductionCalculator.call(rate_table: rate_tables(:sss_acme), gross: 20000.00)

      assert_equal 202.50, deduction
    end

    test "SSS: falls into the lowest bracket" do
      deduction = Payroll::StatutoryDeductionCalculator.call(rate_table: rate_tables(:sss_acme), gross: 3000.00)

      assert_equal 180.00, deduction
    end

    test "BIR: base amount plus percent over excess" do
      # 20000 falls in the 16666.67-and-up bracket: 937.50 + 20% * (20000 - 16666.67)
      deduction = Payroll::StatutoryDeductionCalculator.call(rate_table: rate_tables(:bir_acme), gross: 20000.00)

      assert_in_delta 1604.166, deduction, 0.01
    end

    test "BIR: zero in the tax-exempt bracket" do
      deduction = Payroll::StatutoryDeductionCalculator.call(rate_table: rate_tables(:bir_acme), gross: 5000.00)

      assert_equal 0.0, deduction
    end

    test "PhilHealth: flat percent of gross, no brackets" do
      deduction = Payroll::StatutoryDeductionCalculator.call(rate_table: rate_tables(:philhealth_acme), gross: 20000.00)

      assert_equal 500.0, deduction
    end

    test "PhilHealth: clamps gross to the income ceiling" do
      deduction = Payroll::StatutoryDeductionCalculator.call(rate_table: rate_tables(:philhealth_acme), gross: 500_000.00)

      assert_equal 2500.0, deduction
    end

    test "PhilHealth: clamps gross to the income floor" do
      deduction = Payroll::StatutoryDeductionCalculator.call(rate_table: rate_tables(:philhealth_acme), gross: 1000.00)

      assert_equal 250.0, deduction
    end

    test "Pag-IBIG: bracket-based like SSS, returns the matching bracket's employee_share" do
      deduction = Payroll::StatutoryDeductionCalculator.call(rate_table: rate_tables(:pagibig_acme), gross: 20000.00)

      assert_equal 100.00, deduction
    end

    test "returns 0 for an untouched placeholder rate table" do
      untouched = RateTable.new(brackets: [], fields: {})

      assert_equal 0, Payroll::StatutoryDeductionCalculator.call(rate_table: untouched, gross: 20000.00)
    end
  end
end
