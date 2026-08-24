module LeaveRequests
  # Reused by Team::CalendarController#show. Same viewer-scoping shape
  # as AttendanceCorrectionRequests::PendingForApprover (admin sees the
  # whole company, manager sees only their own direct reports) — see
  # kos/decisions/ui/team-calendar-week-agenda.md, which carries over
  # the same team as team-approvals-inbox-inline-actions.
  #
  # Date-range overlap needs Arel (an OR/AND combo a plain .where hash
  # can't express cleanly) — see kos/decisions/rails-arel-for-complex-queries.md.
  class OutForWeek
    def self.call(viewer:, week_start:)
      return LeaveRequest.none unless viewer.manager? || viewer.admin?

      week_end = week_start + 6.days
      t = LeaveRequest.arel_table
      scope = LeaveRequest.where.not(status: :rejected)
                          .where(t[:start_date].lteq(week_end).and(t[:end_date].gteq(week_start)))
                          .includes(:employee, :leave_type)

      scope = viewer.admin? ? scope.joins(:employee).where(employees: { company_id: viewer.company_id })
                            : scope.joins(:employee).where(employees: { manager_id: viewer.id })
      scope.order(:start_date)
    end
  end
end
