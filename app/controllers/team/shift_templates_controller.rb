# Owns create/update/destroy only — the list renders as a drawer on
# Team::AttendanceRecordsController#index (same "narrow controller,
# redirects back to the merged page" pattern as
# Team::AttendanceSettingsController). Plain controller, no Interactor —
# field-only CRUD with no business-flow side effects.
module Team
  class ShiftTemplatesController < ApplicationController
    include LoadsAttendanceIndexData

    def create
      @shift_template = policy_scope(ShiftTemplate).build(shift_template_params)
      authorize @shift_template

      if @shift_template.save
        redirect_to team_attendance_records_path(open_shift_templates: true), notice: "#{@shift_template.name} added."
      else
        flash.now[:alert] = @shift_template.errors.full_messages.to_sentence
        reopen_templates_drawer
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
        redirect_to team_attendance_records_path(open_shift_templates: true), notice: "#{@shift_template.name} updated."
      else
        flash.now[:alert] = @shift_template.errors.full_messages.to_sentence
        @reopen_shift_template_id = @shift_template.id
        reopen_templates_drawer
      end
    end

    def destroy
      @shift_template = ShiftTemplate.find(params[:id])
      authorize @shift_template

      if @shift_template.destroy
        redirect_to team_attendance_records_path(open_shift_templates: true), notice: "#{@shift_template.name} deleted."
      else
        redirect_to team_attendance_records_path(open_shift_templates: true), alert: @shift_template.errors.full_messages.to_sentence
      end
    end

    private

    def shift_template_params
      params.require(:shift_template).permit(:name, :start_time, :end_time)
    end

    # A failed create/update re-renders the merged Team Attendance index
    # (this controller doesn't own a page of its own) with the "Shift
    # templates" drawer forced back open and @shift_template still
    # holding its validation errors — same reopen-on-error trick as
    # Team::AttendanceRecordsController#update.
    def reopen_templates_drawer
      @open_shift_templates = true
      load_index_data
      render "team/attendance_records/index", status: :unprocessable_entity
    end
  end
end
