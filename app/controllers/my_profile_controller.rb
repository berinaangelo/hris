# Always scoped to current_employee — no :id param, nothing else is
# reachable through this controller, so no Pundit check needed.
class MyProfileController < ApplicationController
  def show
    @onboarding_items = current_employee.checklist_items.onboarding.order(:position)
    @documents = current_employee.documents
  end

  def edit
  end

  def update
    if current_employee.update(profile_params)
      redirect_to my_profile_path, notice: "Saved."
    else
      flash.now[:alert] = current_employee.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:employee).permit(
      :personal_email, :mobile_number, :home_address, :birthdate,
      :emergency_contact_name, :emergency_contact_phone
    )
  end
end
