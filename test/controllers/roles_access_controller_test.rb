require "test_helper"

class RolesAccessControllerTest < ActionDispatch::IntegrationTest
  test "admin can view the roster" do
    sign_in employees(:admin_amy)

    get roles_access_index_path

    assert_response :success
  end

  test "manager is forbidden" do
    sign_in employees(:manager_jane)

    get roles_access_index_path
    assert_redirected_to root_path

    patch roles_access_path(employees(:worker_bob)), params: { employee: { role: "manager" } }
    assert_redirected_to root_path
  end

  test "plain employee is forbidden" do
    sign_in employees(:worker_bob)

    get roles_access_index_path
    assert_redirected_to root_path
  end

  test "admin can change another employee's role" do
    sign_in employees(:admin_amy)
    worker = employees(:worker_bob)

    patch roles_access_path(worker), params: { employee: { role: "manager" } }

    assert_redirected_to roles_access_index_path
    assert worker.reload.manager?
  end

  test "admin can change their own role once another admin exists" do
    sign_in employees(:admin_amy)
    amy = employees(:admin_amy)
    worker = employees(:worker_bob)

    patch roles_access_path(worker), params: { employee: { role: "admin" } }
    assert worker.reload.admin?

    patch roles_access_path(amy), params: { employee: { role: "manager" } }

    assert_redirected_to roles_access_index_path
    assert amy.reload.manager?
  end

  test "sole admin cannot be reassigned away from Admin, and the drawer reopens on the roster" do
    sign_in employees(:admin_amy)
    amy = employees(:admin_amy)

    patch roles_access_path(amy), params: { employee: { role: "manager" } }

    assert_response :unprocessable_entity
    assert amy.reload.admin?
    # Re-renders the roster (index), not a standalone edit page — the
    # drawer for this employee comes back forced open via
    # data-modal-open-value, same reopen-on-error trick as the other
    # drawers in this batch.
    assert_select "table.dirtable"
    assert_select "[data-modal-open-value=true]"
  end

  test "role change is forbidden for an offboarding employee" do
    sign_in employees(:admin_amy)
    departing = employees(:worker_offboarding)

    patch roles_access_path(departing), params: { employee: { role: "manager" } }
    assert_redirected_to root_path
    assert departing.reload.employee?
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
