class AccountSettingsController < ApplicationController
  def show
  end

  def update
    if current_employee.update(notification_params)
      redirect_to account_settings_path, notice: "Preferences saved."
    else
      flash.now[:alert] = current_employee.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.require(:employee).permit(
      :leave_request_updates_notifications, :new_payslip_notifications,
      :review_cycle_notifications, :company_announcement_notifications
    )
  end
end
