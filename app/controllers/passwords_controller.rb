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
      flash.now[:alert] = result.message
      render :edit, status: :unprocessable_entity
    end
  end
end
