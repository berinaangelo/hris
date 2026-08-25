require "test_helper"

module ReviewCycles
  class AttachKpiEntriesTest < ActiveJob::TestCase
    test "attaches kpi entries to a shell cycle and notifies the employee" do
      review_cycle = ReviewCycle.create!(
        employee: employees(:worker_bob), cycle_type: :regular,
        start_date: Date.current, end_date: 6.months.from_now.to_date, status: :in_progress
      )

      assert_enqueued_with(job: CycleOpenedNotifierJob) do
        result = ReviewCycles::AttachKpiEntries.call(
          review_cycle: review_cycle,
          kpi_entries_params: [
            { kpi_name: "Ship feature X", target: "By Q3" },
            { kpi_name: "Reduce bugs", target: "Under 5 open" },
            { kpi_name: "Mentor a junior", target: "Weekly 1:1s" }
          ]
        )

        assert result.success?
      end

      assert_equal 3, review_cycle.kpi_entries.count
    end
  end
end
