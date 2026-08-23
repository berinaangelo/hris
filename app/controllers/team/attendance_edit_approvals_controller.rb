module Team
  class AttendanceEditApprovalsController < ApplicationController
    def index
      authorize :team_attendance_edit_approval, :index?

      @pending = AttendanceRecords::PendingApproverSignoff.call(current_employee)
      @decided = AttendanceRecord.where(edit_approved_by: current_employee).where.not(edit_approval_status: :pending)
                                  .includes(:employee).order(edit_approved_at: :desc).limit(10)
    end

    def approve
      attendance_record = AttendanceRecord.find(params[:id])
      authorize attendance_record, :approve_edit?

      ActiveRecord::Base.transaction do
        AttendanceEditApproval::ApproveEdit.call!(attendance_record: attendance_record, approver: current_employee)
      end
      redirect_to team_attendance_edit_approvals_path,
                  notice: "Approved #{attendance_record.employee.full_name}'s attendance edit."
    rescue Interactor::Failure => e
      redirect_to team_attendance_edit_approvals_path, alert: e.context.message
    end

    def reject
      attendance_record = AttendanceRecord.find(params[:id])
      authorize attendance_record, :reject_edit?

      result = AttendanceEditApproval::RejectEdit.call(attendance_record: attendance_record, approver: current_employee)

      if result.success?
        redirect_to team_attendance_edit_approvals_path,
                    notice: "Rejected #{attendance_record.employee.full_name}'s attendance edit."
      else
        redirect_to team_attendance_edit_approvals_path, alert: result.message
      end
    end
  end
end
