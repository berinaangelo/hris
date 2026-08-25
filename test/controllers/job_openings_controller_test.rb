require "test_helper"

class JobOpeningsControllerTest < ActionDispatch::IntegrationTest
  test "admin can view job openings" do
    sign_in employees(:admin_amy)

    get job_openings_path

    assert_response :success
  end

  test "manager is forbidden" do
    sign_in employees(:manager_jane)

    get job_openings_path

    assert_redirected_to root_path
  end

  test "admin can create a job opening with an auto-generated slug" do
    sign_in employees(:admin_amy)

    assert_difference "JobOpening.count", 1 do
      post job_openings_path, params: { job_opening: { title: "Product Designer", description: "Design things.", status: "open" } }
    end

    assert_equal "product-designer", JobOpening.last.slug
    assert_redirected_to job_opening_path(JobOpening.last)
  end

  test "creating a job opening fails validation with a blank title" do
    sign_in employees(:admin_amy)

    assert_no_difference "JobOpening.count" do
      post job_openings_path, params: { job_opening: { title: "", description: "Design things.", status: "open" } }
    end

    assert_response :unprocessable_entity
  end

  test "admin can update a job opening" do
    sign_in employees(:admin_amy)
    job_opening = job_openings(:acme_engineer_opening)

    patch job_opening_path(job_opening), params: { job_opening: { title: "Staff Engineer", description: job_opening.description, status: "closed" } }

    assert_redirected_to job_opening_path(job_opening)
    job_opening.reload
    assert_equal "Staff Engineer", job_opening.title
    assert job_opening.closed?
  end

  test "updating a job opening fails validation with a blank title" do
    sign_in employees(:admin_amy)
    job_opening = job_openings(:acme_engineer_opening)

    patch job_opening_path(job_opening), params: { job_opening: { title: "", description: job_opening.description, status: "open" } }

    assert_response :unprocessable_entity
  end

  test "admin can view the kanban detail with candidates grouped by stage" do
    sign_in employees(:admin_amy)

    get job_opening_path(job_openings(:acme_engineer_opening))

    assert_response :success
    assert_match "Juan Dela Cruz", response.body
    assert_match "Maria Santos", response.body
  end

  test "admin cannot reach another company's job opening" do
    sign_in employees(:admin_gary)

    get job_opening_path(job_openings(:acme_engineer_opening))

    assert_response :not_found
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
