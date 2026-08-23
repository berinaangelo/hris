require "test_helper"

module Team
  class ReviewCyclesControllerTest < ActionDispatch::IntegrationTest
    test "manager can view their team roster" do
      sign_in employees(:manager_jane)

      get team_review_cycles_path

      assert_response :success
    end

    test "a plain employee is forbidden" do
      sign_in employees(:worker_bob)

      get team_review_cycles_path

      assert_redirected_to root_path
    end

    test "manager can open a new cycle with kpis for a direct report" do
      sign_in employees(:manager_jane)
      employee = employees(:worker_bob)

      assert_difference "ReviewCycle.count", 1 do
        post team_review_cycles_path, params: {
          review_cycle: { employee_id: employee.id, cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date },
          kpi_entries: [
            { kpi_name: "Ship feature X", target: "By Q3" },
            { kpi_name: "Reduce bugs", target: "Under 5 open" }
          ]
        }
      end

      assert_redirected_to team_review_cycles_path(employee_id: employee.id)
      assert_equal 2, ReviewCycle.last.kpi_entries.count
    end

    test "manager cannot open a cycle for someone who isn't their direct report" do
      sign_in employees(:manager_jane)
      employee = employees(:worker_carol) # managed by manager_optout, not manager_jane

      assert_no_difference "ReviewCycle.count" do
        post team_review_cycles_path, params: {
          review_cycle: { employee_id: employee.id, cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date },
          kpi_entries: []
        }
      end

      assert_redirected_to root_path
    end

    test "manager can save a draft score for their direct report's cycle" do
      sign_in employees(:manager_jane)
      review_cycle = review_cycles(:alice_awaiting_scoring)
      kpi_entry = kpi_entries(:alice_kpi_1)

      patch save_draft_team_review_cycle_path(review_cycle), params: {
        kpi_entries: { kpi_entry.id => { actual: "8 open bugs", score: "4" } }, manager_comment: "Progress."
      }

      assert_redirected_to team_review_cycles_path(employee_id: review_cycle.employee_id)
      assert_equal 4, kpi_entry.reload.score
    end

    test "manager is forbidden from scoring a cycle outside their team" do
      sign_in employees(:manager_jane)
      review_cycle = review_cycles(:carol_in_progress) # carol's manager is manager_optout

      patch save_draft_team_review_cycle_path(review_cycle), params: { kpi_entries: {}, manager_comment: nil }

      assert_redirected_to root_path
    end

    test "manager can publish once every kpi is scored" do
      sign_in employees(:manager_jane)
      review_cycle = review_cycles(:alice_awaiting_scoring)
      alice_kpi_1 = kpi_entries(:alice_kpi_1)
      alice_kpi_2 = kpi_entries(:alice_kpi_2)

      patch publish_team_review_cycle_path(review_cycle), params: {
        kpi_entries: {
          alice_kpi_1.id => { actual: "8 open bugs", score: "4" },
          alice_kpi_2.id => { actual: "Shipped on time", score: "5" }
        },
        manager_comment: "Great cycle."
      }

      assert_redirected_to team_review_cycles_path(employee_id: review_cycle.employee_id)
      assert review_cycle.reload.published?
    end

    test "publishing fails and redirects with an alert when a kpi is left unscored" do
      sign_in employees(:manager_jane)
      review_cycle = review_cycles(:alice_awaiting_scoring)

      patch publish_team_review_cycle_path(review_cycle), params: { kpi_entries: {}, manager_comment: nil }

      assert_redirected_to team_review_cycles_path(employee_id: review_cycle.employee_id)
      assert_not review_cycle.reload.published?
    end

    test "manager cannot edit an already-published cycle" do
      sign_in employees(:manager_jane)
      review_cycle = review_cycles(:bob_published_regular)

      patch save_draft_team_review_cycle_path(review_cycle), params: { kpi_entries: {}, manager_comment: "Too late" }

      assert_redirected_to root_path
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
