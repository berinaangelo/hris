# Shared "current balance" lookup for Home Dashboard's hero and Time
# Off's balance-mini card — v1 shows one balance figure (the company's
# primary leave type), not a per-type list. See
# kos/decisions/ui/home-dashboard-balance-led-hero.md.
module LoadsPrimaryLeaveBalance
  extend ActiveSupport::Concern

  private

  def current_leave_balance
    primary_leave_type = LeaveType.where(company: current_employee.company).first
    return unless primary_leave_type

    current_employee.leave_balances.find_by(leave_type: primary_leave_type, year: Date.current.year)
  end
end
