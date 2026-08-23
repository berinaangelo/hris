class DashboardController < ApplicationController
  def show
    @leave_balance = current_leave_balance
    @leave_requests = current_employee.leave_requests.includes(:leave_type).order(created_at: :desc).limit(5)
    @pending_approvals_count = LeaveRequests::PendingForApprover.call(current_employee).count
  end

  private

  # v1's Home dashboard shows one balance figure (the hero), per
  # kos/decisions/ui/home-dashboard-balance-led-hero.md — the
  # company's primary leave type (e.g. "Vacation"), not a per-type list.
  def current_leave_balance
    primary_leave_type = LeaveType.where(company: current_employee.company).first
    return unless primary_leave_type

    current_employee.leave_balances.find_by(leave_type: primary_leave_type, year: Date.current.year)
  end
end
