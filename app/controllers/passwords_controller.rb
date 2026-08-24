class PasswordsController < ApplicationController
  def edit
  end

  def update
    result = Account::ChangePassword.call(
      employee: current_employee,
      current_password: params[:current_password],
      new_password: params[:new_password],
      new_password_confirmation: params[:new_password_confirmation]
    )

    if result.success?
      redirect_to account_settings_path, notice: "Password changed."
    else
      # "Change password" now lives as a modal on Account Settings (see
      # kos/decisions/ui/account-settings-summary-plus-modal.md) rather
      # than a standalone page, so a failed submit re-renders that page
      # with the modal forced back open instead of :edit.
      @password_errors = result.message
      @open_password_modal = true
      render "account_settings/show", status: :unprocessable_entity
    end
  end
end
