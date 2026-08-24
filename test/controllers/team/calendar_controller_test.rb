require "test_helper"

module Team
  class CalendarControllerTest < ActionDispatch::IntegrationTest
    test "manager sees their direct reports' approved and pending leave for the week" do
      sign_in employees(:manager_jane)

      get team_calendar_path(week_start: "2026-08-31")

      assert_response :success
      assert_match "Bob Worker", response.body
      assert_match "Alice OptedOut", response.body
    end

    test "manager does not see another manager's team" do
      sign_in employees(:manager_jane)

      get team_calendar_path(week_start: "2026-08-31")

      assert_no_match "Carol Reports", response.body
    end

    test "a day with nobody out says so" do
      sign_in employees(:manager_jane)

      get team_calendar_path(week_start: "2026-09-07")

      assert_response :success
      assert_match "No one out", response.body
    end

    test "employee without manager/admin role cannot view the team calendar" do
      sign_in employees(:worker_bob)

      get team_calendar_path

      assert_redirected_to root_path
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
