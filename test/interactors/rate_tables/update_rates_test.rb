require "test_helper"

module RateTables
  class UpdateRatesTest < ActiveSupport::TestCase
    test "replaces brackets and fields outright" do
      rate_table = rate_tables(:philhealth_acme)

      result = RateTables::UpdateRates.call(
        rate_table: rate_table,
        effective_date: 1.day.ago.to_date,
        brackets_json: nil,
        fields_json: '{"employee_share_percent": 3.0}',
        updated_by: employees(:admin_amy)
      )

      assert result.success?
      rate_table.reload
      assert_equal 3.0, rate_table.fields["employee_share_percent"]
      assert_equal employees(:admin_amy), rate_table.updated_by
    end

    test "fails on invalid JSON" do
      rate_table = rate_tables(:sss_acme)

      result = RateTables::UpdateRates.call(
        rate_table: rate_table,
        effective_date: Date.current,
        brackets_json: "{not valid json",
        fields_json: nil,
        updated_by: employees(:admin_amy)
      )

      assert result.failure?
    end
  end
end
