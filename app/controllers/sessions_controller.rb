class SessionsController < ApplicationController
  skip_before_action :require_employee, only: [ :new, :create ]

  def new
  end

  def create
    employee = Employee.find_by(work_email: params[:work_email]&.downcase)

    if employee&.authenticate(params[:password])
      session[:employee_id] = employee.id
      employee.update_column(:last_login_at, Time.current)
      remember_or_forget(employee)
      redirect_to root_path, notice: "Welcome back, #{employee.first_name}."
    else
      @login_error = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:employee_id)
    cookies.delete(:employee_id)
    redirect_to new_session_path, notice: "Signed out."
  end

  private

  # Lightweight remember-me: extends the existing signed employee_id
  # cookie's lifetime rather than a rotating DB-backed remember token —
  # flagged in kos/decisions/ui/login-page-split-panel.md as "cheap to
  # drop if unwanted," so kept proportionate to that.
  def remember_or_forget(employee)
    if params[:remember_me] == "1"
      cookies.permanent.signed[:employee_id] = employee.id
    else
      cookies.delete(:employee_id)
    end
  end
end
