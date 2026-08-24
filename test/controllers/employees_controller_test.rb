require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  test "admin sees the roster, offboarded hidden by default" do
    sign_in employees(:admin_amy)
    offboarded = employees(:worker_bob)
    offboarded.update!(status: :offboarded, last_working_day: 1.week.ago)

    get employees_path

    assert_response :success
    assert_select "h4", text: "Jane Manager"
    assert_select "h4", text: offboarded.full_name, count: 0
  end

  test "show_offboarded reveals the terminal Offboarded state" do
    sign_in employees(:admin_amy)
    offboarded = employees(:worker_bob)
    offboarded.update!(status: :offboarded, last_working_day: 1.week.ago)

    get employees_path(show_offboarded: 1)

    assert_response :success
    assert_select "h4", text: offboarded.full_name
  end

  test "Offboarding (not yet Offboarded) always shows" do
    sign_in employees(:admin_amy)

    get employees_path

    assert_response :success
    assert_select "h4", text: employees(:worker_offboarding).full_name
  end

  test "manager is forbidden from the roster" do
    sign_in employees(:manager_jane)

    get employees_path

    assert_redirected_to root_path
  end

  test "admin sees an employee's Profile, Loan Ledger, and Benefits tabs" do
    sign_in employees(:admin_amy)
    employee = employees(:worker_bob)

    get employee_path(employee)

    assert_response :success
    assert_select "button", text: "Loan Ledger"
    assert_select "button", text: "Benefits"
  end

  test "admin can update an employee's personal & contact section" do
    sign_in employees(:admin_amy)
    employee = employees(:worker_bob)

    patch employee_path(employee), params: {
      section: "personal",
      employee: { first_name: employee.first_name, last_name: employee.last_name, mobile_number: "0917 555 0000" }
    }

    assert_redirected_to employee_path(employee)
    assert_equal "0917 555 0000", employee.reload.mobile_number
  end

  test "invalid update re-renders show with the section reopened" do
    sign_in employees(:admin_amy)
    employee = employees(:worker_bob)

    patch employee_path(employee), params: {
      section: "personal",
      employee: { first_name: "", last_name: employee.last_name }
    }

    assert_response :unprocessable_entity
    assert_select "form[id=personal-contact-form][hidden]", count: 0
  end

  test "admin schedules offboarding, status becomes Offboarding" do
    sign_in employees(:admin_amy)
    employee = employees(:worker_bob)

    patch schedule_offboarding_employee_path(employee), params: {
      last_working_day: 2.weeks.from_now.to_date, offboarding_reason: "Resignation", rehire_eligible: "1"
    }

    assert_redirected_to employee_path(employee)
    assert employee.reload.offboarding?
    assert_equal 4, employee.checklist_items.offboarding.count
  end

  test "mark_offboarded is blocked until the last working day passes and clearance is done" do
    sign_in employees(:admin_amy)
    employee = employees(:worker_offboarding)
    employee.update!(last_working_day: 1.week.from_now)

    patch mark_offboarded_employee_path(employee)

    assert_redirected_to employee_path(employee)
    assert employee.reload.offboarding?
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
