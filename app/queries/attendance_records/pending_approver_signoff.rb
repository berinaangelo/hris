module AttendanceRecords
  # Admin-only by design — no manager branch, unlike
  # AttendanceCorrectionRequests::PendingForApprover. NOT a
  # payroll-eligibility filter — edit_approval_status is oversight
  # only; do not reuse this scope (or .edit_approval_pending itself) to
  # gate what payroll reads.
  class PendingApproverSignoff
    def self.call(approver)
      return AttendanceRecord.none unless approver.admin?

      AttendanceRecord.edit_approval_pending
                       .joins(:employee)
                       .where(employees: { company_id: approver.company_id })
                       .includes(:employee, :edited_by)
                       .order(edited_at: :asc)
    end
  end
end
