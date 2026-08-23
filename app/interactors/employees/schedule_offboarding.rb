module Employees
  class ScheduleOffboarding
    include Interactor

    def call
      employee = context.employee

      unless employee.active?
        context.fail!(message: "This employee isn't active.")
        return
      end

      employee.update!(
        status: :offboarding,
        last_working_day: context.last_working_day,
        offboarding_reason: context.offboarding_reason,
        rehire_eligible: context.rehire_eligible,
        offboarding_notes: context.offboarding_notes
      )

      rows = Employee::OFFBOARDING_ITEM_KEYS.each_with_index.map do |key, index|
        {
          employee_id: employee.id,
          checklist_type: ChecklistItem.checklist_types.fetch(:offboarding),
          item_key: key,
          position: index,
          created_at: Time.current,
          updated_at: Time.current
        }
      end
      ChecklistItem.insert_all(rows)
    end
  end
end
