require "test_helper"

# Covers app/presenters/navigation_presenter.rb as exercised through the
# real layout (app/views/layouts/application.html.erb) — the Me/Team/
# Company pill bar plus its section sidebar, see
# kos/decisions/ui/navigation-me-team-company.md.
class NavigationTest < ActionDispatch::IntegrationTest
  test "employee only sees the Me tab and its sidebar" do
    sign_in employees(:worker_bob)

    get root_path

    assert_select ".nav-tabs a", count: 1
    assert_select ".nav-tabs a.active", text: "Me"
    assert_select ".side-nav a", count: 6
    assert_select ".side-nav a.active", text: /Home/

    assert_select "a[href=?]", team_approvals_path, count: 0
    assert_select "a[href=?]", employees_path, count: 0
  end

  test "manager sees Me and Team, not Company" do
    sign_in employees(:manager_jane)

    get team_approvals_path

    assert_select ".nav-tabs a", count: 2
    assert_select ".nav-tabs a.active", text: /Team/
    assert_select ".side-nav a", count: 4
    assert_select ".side-nav a.active", text: /Approvals/

    assert_select "a[href=?]", employees_path, count: 0
  end

  test "admin sees all three tabs, Company sidebar has every item" do
    sign_in employees(:admin_amy)

    get employees_path

    assert_select ".nav-tabs a", count: 3
    assert_select ".nav-tabs a.active", text: "Company"
    assert_select ".side-nav a", count: 11
    assert_select ".side-nav a.active", text: /People/
  end

  test "Attendance Sign-offs is Company-tier despite its team/ controller namespace" do
    sign_in employees(:admin_amy)

    get team_attendance_edit_approvals_path

    assert_select ".nav-tabs a.active", text: "Company"
    assert_select ".side-nav a.active", text: /Attendance Sign-offs/
  end

  test "a nested employee sub-page still highlights People" do
    sign_in employees(:admin_amy)

    get employee_path(employees(:worker_bob))

    assert_select ".side-nav a.active", text: /People/
  end

  test "pending counts show on the Approvals item and the Team tab, and are absent when zero" do
    sign_in employees(:manager_jane)

    get team_approvals_path

    assert_select ".side-nav a", text: /Approvals/ do
      assert_select ".badge", text: "2"
    end
    # Team tab's badge sums every Team item's count — Approvals (2) +
    # Team Attendance (2, from attendance_correction_requests fixtures
    # managed by manager_jane) = 4.
    assert_select ".nav-tabs a.active .badge", text: "4"

    sign_in employees(:admin_amy)
    get employees_path

    assert_select ".side-nav a", text: /Attendance Sign-offs/ do
      assert_select ".badge", count: 0
    end
  end

  test "an admin drilling into another employee's payslip is treated as Company, not Me" do
    sign_in employees(:admin_amy)
    payslip = payslips(:bob_september_payslip)

    get payslip_path(payslip)

    # Company tab lights up (not Me) even though this is still
    # PayslipsController#show — see navigation_presenter.rb's
    # section_override. No single sidebar item owns this drill-in page
    # (it isn't a section landing page, it's reached via Payroll), so
    # the sidebar renders Company's items with none highlighted rather
    # than mislabeling one as active.
    assert_select ".nav-tabs a.active", text: "Company"
    assert_select ".side-nav a", count: 11
    assert_select ".side-nav a.active", count: 0
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
