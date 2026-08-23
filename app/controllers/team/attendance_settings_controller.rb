module Team
  class AttendanceSettingsController < ApplicationController
    def update
      authorize :attendance_settings, :update?

      if current_employee.company.update(attendance_settings_params)
        redirect_to team_attendance_records_path, notice: "Attendance settings saved."
      else
        redirect_to team_attendance_records_path, alert: current_employee.company.errors.full_messages.to_sentence
      end
    end

    private

    def attendance_settings_params
      params.require(:company).permit(:attendance_manual_edit_enabled, :attendance_approvers_enabled)
    end
  end
end
