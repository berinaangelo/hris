module Team
  class ApprovalsController < ApplicationController
    def index
      authorize :team_approval, :index?

      @pending = LeaveRequests::PendingForApprover.call(current_employee)
      @decided = LeaveRequest.where(approver: current_employee).where.not(status: :pending)
                             .includes(:employee, :leave_type).order(decided_at: :desc).limit(10)
    end

    def approve
      leave_request = LeaveRequest.find(params[:id])
      authorize leave_request, :approve?

      ActiveRecord::Base.transaction { Leave::ApproveRequest.call!(leave_request: leave_request) }
      redirect_to team_approvals_path, notice: "Approved #{leave_request.employee.full_name}'s request."
    rescue Interactor::Failure => e
      redirect_to team_approvals_path, alert: e.context.message
    end

    def reject
      leave_request = LeaveRequest.find(params[:id])
      authorize leave_request, :reject?

      result = Leave::RejectRequest.call(leave_request: leave_request, decision_note: params[:decision_note])

      if result.success?
        redirect_to team_approvals_path, notice: "Rejected #{leave_request.employee.full_name}'s request."
      else
        redirect_to team_approvals_path, alert: result.message
      end
    end
  end
end
