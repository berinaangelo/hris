class DashboardController < ApplicationController
  include LoadsPrimaryLeaveBalance

  def show
    @leave_balance = current_leave_balance
    @leave_requests = current_employee.leave_requests.includes(:leave_type).order(created_at: :desc).limit(5)
    @pending_my_requests_count = current_employee.leave_requests.pending.count
    @ytd_approved_count = current_employee.leave_requests.approved.where(created_at: Date.current.beginning_of_year..).count
    @ytd_rejected_count = current_employee.leave_requests.rejected.where(created_at: Date.current.beginning_of_year..).count
    @pending_approvals_count = LeaveRequests::PendingForApprover.call(current_employee).count
    @pending_correction_requests_count = AttendanceCorrectionRequests::PendingForApprover.call(current_employee).count
    @todays_attendance_record = current_employee.attendance_records.find_by(date: current_employee.company.today)
  end
end
