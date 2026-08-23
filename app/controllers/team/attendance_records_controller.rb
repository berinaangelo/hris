module Team
  class AttendanceRecordsController < ApplicationController
    def index
      authorize AttendanceRecord
      @start_date = parse_date(params[:start_date]) || 14.days.ago.to_date
      @end_date = parse_date(params[:end_date]) || Date.current
      @attendance_records = AttendanceRecords::ForDateRange.call(
        viewer: current_employee, start_date: @start_date, end_date: @end_date
      )
    end

    def edit
      @attendance_record = AttendanceRecord.find(params[:id])
      authorize @attendance_record
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
        flash.now[:alert] = result.message
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def attendance_record_params
      params.require(:attendance_record).permit(:clock_in_at, :clock_out_at)
    end

    def parse_date(value)
      value.presence&.to_date
    rescue ArgumentError, TypeError
      nil
    end
  end
end
