require "test_helper"

class CertificationsControllerTest < ActionDispatch::IntegrationTest
  test "admin can view the list" do
    sign_in employees(:admin_amy)

    get certifications_path

    assert_response :success
  end

  test "manager is forbidden" do
    sign_in employees(:manager_jane)

    get certifications_path
    assert_redirected_to root_path

    get new_certification_path
    assert_redirected_to root_path

    post certifications_path, params: { certification: { employee_id: employees(:worker_bob).id, cert_name: "Test", expiry_date: 1.year.from_now.to_date } }
    assert_redirected_to root_path
  end

  test "plain employee is forbidden" do
    sign_in employees(:worker_bob)

    get certifications_path
    assert_redirected_to root_path
  end

  test "admin can add a certification" do
    sign_in employees(:admin_amy)
    employee = employees(:worker_bob)

    assert_difference "Certification.count", 1 do
      post certifications_path, params: { certification: { employee_id: employee.id, cert_name: "Safety Officer", expiry_date: 1.year.from_now.to_date } }
    end

    assert_redirected_to certifications_path
  end

  test "adding a certification fails validation with a blank name" do
    sign_in employees(:admin_amy)
    employee = employees(:worker_bob)

    assert_no_difference "Certification.count" do
      post certifications_path, params: { certification: { employee_id: employee.id, cert_name: "", expiry_date: 1.year.from_now.to_date } }
    end

    assert_response :unprocessable_entity
  end

  test "admin can update a certification" do
    sign_in employees(:admin_amy)
    certification = certifications(:carol_forklift_expiring_soon)

    patch certification_path(certification), params: { certification: { employee_id: certification.employee_id, cert_name: certification.cert_name, expiry_date: 2.years.from_now.to_date } }

    assert_redirected_to certifications_path
    assert_equal 2.years.from_now.to_date, certification.reload.expiry_date
  end

  test "admin can delete a certification" do
    sign_in employees(:admin_amy)
    certification = certifications(:carol_forklift_expiring_soon)

    assert_difference "Certification.count", -1 do
      delete certification_path(certification)
    end

    assert_redirected_to certifications_path
  end

  test "admin cannot reach another company's certification" do
    sign_in employees(:admin_gary)

    get edit_certification_path(certifications(:carol_forklift_expiring_soon))

    assert_response :not_found
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
