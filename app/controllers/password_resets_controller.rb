# Forgot/reset password — pre-auth, net new (no prior backend existed
# for this). See kos/decisions/ui/password-recovery-flow-split-panel.md.
#
# The request step (#create) deliberately never discloses whether an
# account exists for the submitted email — it always renders the same
# "link sent" confirmation. Tokens are generated via
# Employee#generate_token_for(:password_reset), which is salted from
# the current password digest, so a token auto-invalidates the moment
# the password changes and needs no separate DB column.
class PasswordResetsController < ApplicationController
  skip_before_action :require_employee

  def new
  end

  def create
    if valid_email_format?(params[:work_email])
      send_reset_link(params[:work_email])
      @sent = true
    else
      @email_error = "Enter a valid work email address."
    end

    render :new, status: @email_error ? :unprocessable_entity : :ok
  end

  def edit
    @employee = Employee.find_by_token_for(:password_reset, params[:token])
    @expired = @employee.nil?
  end

  def update
    @employee = Employee.find_by_token_for(:password_reset, params[:token])

    if @employee.nil?
      @expired = true
    elsif params[:new_password] != params[:new_password_confirmation]
      @confirmation_error = "Passwords don't match."
    else
      @employee.update!(password: params[:new_password], password_changed_at: Time.current)
      @success = true
    end

    render :edit, status: (@confirmation_error ? :unprocessable_entity : :ok)
  end

  private

  def valid_email_format?(email)
    email.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
  end

  def send_reset_link(email)
    employee = Employee.find_by(work_email: email.downcase)
    return unless employee

    token = employee.generate_token_for(:password_reset)
    PasswordResetRequestedNotifierJob.perform_later(employee, token)
  end
end
