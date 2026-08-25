require "test_helper"

module RateTables
  class UpdateRatesTest < ActiveSupport::TestCase
    test "replaces brackets and fields outright" do
      rate_table = rate_tables(:philhealth_acme)

      result = RateTables::UpdateRates.call(
        rate_table: rate_table,
        effective_date: 1.day.ago.to_date,
        brackets: nil,
        fields: { "employee_share_percent" => "3.0" },
        updated_by: employees(:admin_amy)
      )

      assert result.success?
      rate_table.reload
      assert_equal 3.0, rate_table.fields["employee_share_percent"]
      assert_equal employees(:admin_amy), rate_table.updated_by
    end

    test "casts structured bracket params to floats and leaves a blank max open-ended" do
      rate_table = rate_tables(:sss_acme)

      result = RateTables::UpdateRates.call(
        rate_table: rate_table,
        effective_date: Date.current,
        brackets: [
          { "min" => "0", "max" => "4249.99", "employee_share" => "180.00", "employer_share" => "380.00" },
          { "min" => "4250.00", "max" => "", "employee_share" => "202.50", "employer_share" => "427.50" }
        ],
        fields: nil,
        updated_by: employees(:admin_amy)
      )

      assert result.success?
      rate_table.reload
      assert_equal 2, rate_table.brackets.size
      assert_equal 4249.99, rate_table.brackets.first["max"]
      assert_nil rate_table.brackets.last["max"]
      assert_equal 202.5, rate_table.brackets.last["employee_share"]
    end

    test "drops a fully blank bracket row" do
      rate_table = rate_tables(:sss_acme)

      result = RateTables::UpdateRates.call(
        rate_table: rate_table,
        effective_date: Date.current,
        brackets: [
          { "min" => "0", "max" => "", "employee_share" => "180.00", "employer_share" => "380.00" },
          { "min" => "", "max" => "", "employee_share" => "", "employer_share" => "" }
        ],
        fields: nil,
        updated_by: employees(:admin_amy)
      )

      assert result.success?
      assert_equal 1, rate_table.reload.brackets.size
    end

    test "fails when effective_date is blank" do
      rate_table = rate_tables(:sss_acme)

      result = RateTables::UpdateRates.call(
        rate_table: rate_table,
        effective_date: nil,
        brackets: [],
        fields: nil,
        updated_by: employees(:admin_amy)
      )

      assert result.failure?
    end
  end
end
