require "test_helper"

class RateTableTest < ActiveSupport::TestCase
  test "stale? is true when not updated in over a year" do
    rate_table = rate_tables(:bir_acme)
    rate_table.update_column(:updated_at, 2.years.ago)

    assert rate_table.stale?
  end

  test "stale? is false when updated within the last year" do
    rate_table = rate_tables(:sss_acme)
    rate_table.update_column(:updated_at, 1.month.ago)

    assert_not rate_table.stale?
  end

  test "display_name maps agency to its label" do
    assert_equal "Pag-IBIG", rate_tables(:pagibig_acme).display_name
  end
end
