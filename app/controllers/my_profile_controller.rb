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
      # "Edit personal info" now lives as a modal on My Profile (see
      # kos/decisions/ui/my-profile-summary-plus-modal.md) rather than a
      # standalone page, so a failed submit re-renders that page with
      # the modal forced back open instead of :edit.
      @onboarding_items = current_employee.checklist_items.onboarding.order(:position)
      @documents = current_employee.documents
      @open_profile_modal = true
      render :show, status: :unprocessable_entity
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
