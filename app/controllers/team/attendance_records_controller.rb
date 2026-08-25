# Team Attendance — the merged records/corrections/settings page. See
# kos/decisions/ux-pages/time-attendance.html (Option 3) and
# kos/decisions/time-attendance-correction-request-and-manual-edit.md.
# Correction-request approve/reject stay on
# Team::AttendanceCorrectionRequestsController and settings on
# Team::AttendanceSettingsController — both just redirect back here.
module Team
  class AttendanceRecordsController < ApplicationController
    include LoadsAttendanceIndexData

    def index
      authorize AttendanceRecord
      load_index_data
    end

    def update
      @attendance_record = AttendanceRecord.find(params[:id])
      authorize @attendance_record

      result = Attendance::UpdateRecord.call(
        attendance_record: @attendance_record,
        clock_in_at: attendance_record_params[:clock_in_at],
        clock_out_at: attendance_record_params[:clock_out_at],
        editor: current_employee
      )

      if result.success?
        redirect_to team_attendance_records_path,
                    notice: "Updated #{@attendance_record.employee.full_name}'s attendance for #{@attendance_record.date}."
      else
        # The Edit action now lives as a drawer on this same index (see
        # kos/decisions/ux-pages/time-attendance.html), not a standalone
        # page — a failed submit re-renders index with that row's drawer
        # forced back open, same reopen-on-error trick as
        # MyProfileController#update.
        @open_edit_drawer_for_id = @attendance_record.id
        load_index_data
        flash.now[:alert] = result.message
        render :index, status: :unprocessable_entity
      end
    end

    private

    def attendance_record_params
      params.require(:attendance_record).permit(:clock_in_at, :clock_out_at)
    end
  end
end
