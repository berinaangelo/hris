class SessionsController < ApplicationController
  skip_before_action :require_employee, only: [:new, :create]

  def new
  end

  def create
    employee = Employee.find_by(work_email: params[:work_email]&.downcase)

    if employee&.authenticate(params[:password])
      session[:employee_id] = employee.id
      employee.update_column(:last_login_at, Time.current)
      redirect_to root_path, notice: "Welcome back, #{employee.first_name}."
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:employee_id)
    redirect_to new_session_path, notice: "Signed out."
  end
end
