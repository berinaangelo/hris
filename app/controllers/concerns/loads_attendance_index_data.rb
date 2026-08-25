# Shared query set behind Team Attendance's merged index page — pulled
# out of Team::AttendanceRecordsController so Team::ShiftTemplatesController
# (a narrow controller with no page of its own) can re-render the same
# page, with the "Shift templates" drawer forced open, after a failed
# create/update — same reopen-on-error trick as
# Team::AttendanceRecordsController#update itself.
module LoadsAttendanceIndexData
  extend ActiveSupport::Concern

  private

  def load_index_data
    @start_date = parse_date(params[:start_date]) || 14.days.ago.to_date
    @end_date = parse_date(params[:end_date]) || Date.current
    @active_period = active_period

    # Stats always reflect the full period regardless of the status/search
    # filter — only the table itself narrows, per
    # kos/decisions/ui/time-attendance-attendance-first-templates-drawer.md.
    period_records = AttendanceRecords::ForDateRange.call(
      viewer: current_employee, start_date: @start_date, end_date: @end_date
    )
    @status_counts = {
      on_time: period_records.status_on_time.count,
      late: period_records.status_late.count,
      undertime: period_records.status_undertime.count,
      absent: period_records.status_absent.count
    }
    @attendance_records = AttendanceRecords::ForDateRange.call(
      viewer: current_employee, start_date: @start_date, end_date: @end_date, status: params[:status], search: params[:q]
    )

    @correction_pending = AttendanceCorrectionRequests::PendingForApprover.call(current_employee)
    @correction_decided = AttendanceCorrectionRequest.where(reviewed_by: current_employee).where.not(status: :pending)
                                                      .includes(:employee).order(reviewed_at: :desc).limit(10)
    @shift_templates = policy_scope(ShiftTemplate).includes(:employees).order(:start_time) if policy(ShiftTemplate).index?
  end

  def active_period
    return :today if @start_date == Date.current && @end_date == Date.current
    return :this_week if @start_date == Date.current.beginning_of_week && @end_date == Date.current.end_of_week
    return :this_period if @start_date == 14.days.ago.to_date && @end_date == Date.current

    :custom
  end

  def parse_date(value)
    value.presence&.to_date
  rescue ArgumentError, TypeError
    nil
  end
end
