require "test_helper"

module ReviewCycles
  class OpenCycleTest < ActiveJob::TestCase
    test "opens a cycle with its KPI entries and notifies the employee" do
      employee = employees(:worker_bob)

      assert_enqueued_with(job: CycleOpenedNotifierJob) do
        result = ReviewCycles::OpenCycle.call(
          employee: employee,
          cycle_type: "regular",
          start_date: Date.current,
          end_date: 6.months.from_now.to_date,
          kpi_entries_params: [
            { kpi_name: "Ship feature X", target: "Launched by Q3" },
            { kpi_name: "Reduce bugs", target: "Under 5 open" },
            { kpi_name: "Mentor a junior", target: "Weekly 1:1s" }
          ]
        )

        assert result.success?
        assert result.review_cycle.persisted?
        assert_equal 3, result.review_cycle.kpi_entries.count
        assert_equal [ 1, 2, 3 ], result.review_cycle.kpi_entries.order(:position).pluck(:position)
      end
    end

    test "fails without raising when fewer than 3 kpis are submitted" do
      employee = employees(:worker_bob)

      result = ReviewCycles::OpenCycle.call(
        employee: employee, cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date,
        kpi_entries_params: [ { kpi_name: "Ship feature X", target: "By Q3" } ]
      )

      assert result.failure?
      assert_equal "Add between 3 and 5 KPIs, or leave this cycle without KPIs for now.", result.message
    end

    test "fails without raising when more than 5 kpis are submitted" do
      employee = employees(:worker_bob)

      result = ReviewCycles::OpenCycle.call(
        employee: employee, cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date,
        kpi_entries_params: Array.new(6) { |i| { kpi_name: "KPI #{i}", target: "Target #{i}" } }
      )

      assert result.failure?
      assert_equal "Add between 3 and 5 KPIs, or leave this cycle without KPIs for now.", result.message
    end

    test "does not notify the employee when opened as a KPI-less shell" do
      employee = employees(:worker_bob)

      assert_no_enqueued_jobs only: CycleOpenedNotifierJob do
        result = ReviewCycles::OpenCycle.call(
          employee: employee, cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date,
          kpi_entries_params: []
        )

        assert result.success?
        assert result.review_cycle.kpi_entries.empty?
      end
    end

    test "fails without raising when the employee is missing" do
      result = ReviewCycles::OpenCycle.call(
        employee: nil, cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date,
        kpi_entries_params: []
      )

      assert result.failure?
    end

    test "rolls back the cycle if a KPI entry is invalid" do
      employee = employees(:worker_bob)

      assert_no_difference [ "ReviewCycle.count", "KpiEntry.count" ] do
        ActiveRecord::Base.transaction do
          result = ReviewCycles::OpenCycle.call(
            employee: employee, cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date,
            kpi_entries_params: [ { kpi_name: "", target: "Missing a name" } ]
          )
          raise ActiveRecord::Rollback if result.failure?
        end
      end
    end
  end
end
