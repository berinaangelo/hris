require "test_helper"

module Team
  class AttendanceRecordsControllerTest < ActionDispatch::IntegrationTest
    test "manager sees only their direct reports' records in range" do
      sign_in employees(:manager_jane)

      get team_attendance_records_path(start_date: "2026-08-01", end_date: "2026-08-31")

      assert_response :success
      assert_includes response.body, employees(:worker_bob).full_name
      assert_not_includes response.body, employees(:worker_carol).full_name
    end

    test "admin sees every employee's records in range" do
      sign_in employees(:admin_amy)

      get team_attendance_records_path(start_date: "2026-08-01", end_date: "2026-08-31")

      assert_response :success
      assert_includes response.body, employees(:worker_bob).full_name
      assert_includes response.body, employees(:worker_carol).full_name
    end

    test "a malformed date filter falls back to the default range instead of erroring" do
      sign_in employees(:manager_jane)

      get team_attendance_records_path(start_date: "not-a-date")

      assert_response :success
    end

    test "status chip narrows the table but not the stat strip counts" do
      sign_in employees(:admin_amy)

      get team_attendance_records_path(start_date: "2026-08-01", end_date: "2026-08-31", status: "late")

      assert_response :success
      # Scoped to the attendance table itself — both employees also show up
      # in the unrelated "Correction requests" card via other fixtures, so
      # a whole-response_body check would give a false pass/fail here.
      assert_select "table.cptable h4", text: employees(:worker_bob).full_name
      assert_select "table.cptable h4", text: employees(:worker_carol).full_name, count: 0
      # carol_ontime is filtered out of the table above, but the stat strip
      # still counts it — stats reflect the whole period, not the filter.
      assert_select ".stat-tile.dot-positive .num", text: "1"
    end

    test "search narrows the table by employee name" do
      sign_in employees(:admin_amy)

      get team_attendance_records_path(start_date: "2026-08-01", end_date: "2026-08-31", q: "carol")

      assert_response :success
      assert_select "table.cptable h4", text: employees(:worker_carol).full_name
      assert_select "table.cptable h4", text: employees(:worker_bob).full_name, count: 0
    end

    test "period chips mark today/this week/this period active based on the resolved dates" do
      sign_in employees(:manager_jane)

      get team_attendance_records_path(start_date: Date.current, end_date: Date.current)

      assert_response :success
      assert_select "a.chip-filter.is-active", text: "Today"
    end

    test "on-time rows render as plain text, not a badge" do
      sign_in employees(:admin_amy)

      get team_attendance_records_path(start_date: "2026-08-01", end_date: "2026-08-31")

      assert_response :success
      assert_select "span.muted", text: "On time"
      assert_select "span.badge-positive", count: 0
    end

    test "an employee (non-manager, non-admin) is forbidden" do
      sign_in employees(:worker_bob)

      get team_attendance_records_path

      assert_redirected_to root_path
    end

    test "manager can edit their direct report's record" do
      sign_in employees(:manager_jane)
      record = attendance_records(:bob_late)

      patch team_attendance_record_path(record), params: { attendance_record: { clock_in_at: "2026-08-10T09:00:00" } }

      assert_redirected_to team_attendance_records_path
      record.reload
      assert record.manually_edited?
      assert_equal employees(:manager_jane), record.edited_by
    end

    test "admin can edit any record" do
      sign_in employees(:admin_amy)
      record = attendance_records(:carol_ontime)

      patch team_attendance_record_path(record), params: { attendance_record: { clock_in_at: "2026-08-15T09:00:00" } }

      assert_redirected_to team_attendance_records_path
      assert attendance_records(:carol_ontime).reload.manually_edited?
    end

    test "a manager who isn't the employee's manager is forbidden" do
      sign_in employees(:manager_optout)
      record = attendance_records(:bob_late)

      patch team_attendance_record_path(record), params: { attendance_record: { clock_in_at: "2026-08-10T09:00:00" } }

      assert_redirected_to root_path
      assert_not record.reload.manually_edited?
    end

    test "self-edit is forbidden even for a manager" do
      sign_in employees(:manager_jane)
      own_record = employees(:manager_jane).attendance_records.create!(
        date: Date.new(2026, 8, 12), shift_template: shift_templates(:day_shift), clock_in_at: "2026-08-12T09:00:00"
      )

      patch team_attendance_record_path(own_record), params: { attendance_record: { clock_in_at: "2026-08-12T09:30:00" } }

      assert_redirected_to root_path
      assert_not own_record.reload.manually_edited?
    end

    test "self-edit is forbidden even for an admin" do
      sign_in employees(:admin_amy)
      own_record = employees(:admin_amy).attendance_records.create!(
        date: Date.new(2026, 8, 12), shift_template: shift_templates(:day_shift), clock_in_at: "2026-08-12T09:00:00"
      )

      patch team_attendance_record_path(own_record), params: { attendance_record: { clock_in_at: "2026-08-12T09:30:00" } }

      assert_redirected_to root_path
      assert_not own_record.reload.manually_edited?
    end

    test "admin sees the attendance settings card" do
      sign_in employees(:admin_amy)

      get team_attendance_records_path

      assert_response :success
      assert_select "form[action=?]", team_attendance_settings_path
    end

    test "manager doesn't see the attendance settings card" do
      sign_in employees(:manager_jane)

      get team_attendance_records_path

      assert_response :success
      assert_select "form[action=?]", team_attendance_settings_path, count: 0
    end

    test "edit is forbidden when the company has manual edit disabled" do
      sign_in employees(:manager_jane)
      employees(:manager_jane).company.update!(attendance_manual_edit_enabled: false)
      record = attendance_records(:bob_late)

      patch team_attendance_record_path(record), params: { attendance_record: { clock_in_at: "2026-08-10T09:00:00" } }

      assert_redirected_to root_path
      assert_not record.reload.manually_edited?
    end

    test "a manager's edit is pending when approvers are enabled" do
      sign_in employees(:manager_jane)
      employees(:manager_jane).company.update!(attendance_approvers_enabled: true)
      record = attendance_records(:bob_late)

      patch team_attendance_record_path(record), params: { attendance_record: { clock_in_at: "2026-08-10T09:00:00" } }

      assert record.reload.edit_approval_pending?
    end

    test "an admin's edit is never gated even when approvers are enabled" do
      sign_in employees(:admin_amy)
      employees(:admin_amy).company.update!(attendance_approvers_enabled: true)
      record = attendance_records(:carol_ontime)

      patch team_attendance_record_path(record), params: { attendance_record: { clock_in_at: "2026-08-15T09:00:00" } }

      assert record.reload.edit_approval_not_required?
    end

    test "the index shows an approval badge for a pending edit and a dash otherwise" do
      sign_in employees(:admin_amy)
      attendance_records(:bob_late).update!(edit_approval_status: :pending, edited_by: employees(:manager_jane))

      get team_attendance_records_path(start_date: "2026-08-01", end_date: "2026-08-31")

      assert_response :success
      assert_select "span.badge-caution", text: "Pending"
    end

    test "the merged page shows pending correction requests for the manager's own team" do
      sign_in employees(:manager_jane)

      get team_attendance_records_path

      assert_response :success
      assert_match "Correction requests", response.body
      assert_match employees(:worker_bob).full_name, response.body
    end

    test "a failed edit reopens that record's drawer instead of a bare error" do
      sign_in employees(:manager_jane)
      record = attendance_records(:bob_late)

      # Explicit range covering the fixture's date — the default 14-day
      # trailing window drifts past 2026-08-10 as "today" advances, which
      # would silently drop this record out of the reopened index and fail
      # the assertion below for a reason unrelated to what's under test.
      patch team_attendance_record_path(record), params: {
        attendance_record: { clock_out_at: "2026-08-10T08:00:00" },
        start_date: "2026-08-01", end_date: "2026-08-31"
      }

      assert_response :unprocessable_entity
      assert_not record.reload.manually_edited?
      assert_select "span[data-modal-open-value=?]", "true"
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
