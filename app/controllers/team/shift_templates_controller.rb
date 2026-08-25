# Owns create/update/destroy only — the list renders as a drawer on
# Team::AttendanceRecordsController#index (same "narrow controller,
# redirects back to the merged page" pattern as
# Team::AttendanceSettingsController). Plain controller, no Interactor —
# field-only CRUD with no business-flow side effects.
module Team
  class ShiftTemplatesController < ApplicationController
    def create
      @shift_template = policy_scope(ShiftTemplate).build(shift_template_params)
      authorize @shift_template

      if @shift_template.save
        redirect_to team_attendance_records_path, notice: "#{@shift_template.name} added."
      else
        redirect_to team_attendance_records_path, alert: @shift_template.errors.full_messages.to_sentence
      end
    end

    def update
      # Found unscoped, then gated by authorize (not policy_scope) —
      # same trick as AttendanceRecordsController#update — so a
      # cross-company id is a clean 403 redirect via
      # Pundit::NotAuthorizedError, not a bare 404.
      @shift_template = ShiftTemplate.find(params[:id])
      authorize @shift_template

      if @shift_template.update(shift_template_params)
        redirect_to team_attendance_records_path, notice: "#{@shift_template.name} updated."
      else
        redirect_to team_attendance_records_path, alert: @shift_template.errors.full_messages.to_sentence
      end
    end

    def destroy
      @shift_template = ShiftTemplate.find(params[:id])
      authorize @shift_template

      if @shift_template.destroy
        redirect_to team_attendance_records_path, notice: "#{@shift_template.name} deleted."
      else
        redirect_to team_attendance_records_path, alert: @shift_template.errors.full_messages.to_sentence
      end
    end

    private

    def shift_template_params
      params.require(:shift_template).permit(:name, :start_time, :end_time)
    end
  end
end
