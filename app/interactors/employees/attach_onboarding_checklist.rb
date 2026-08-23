module Employees
  class AttachOnboardingChecklist
    include Interactor

    def call
      rows = Employee::ONBOARDING_ITEM_KEYS.each_with_index.map do |key, index|
        {
          employee_id: context.employee.id,
          checklist_type: ChecklistItem.checklist_types.fetch(:onboarding),
          item_key: key,
          position: index,
          created_at: Time.current,
          updated_at: Time.current
        }
      end

      # Bulk insert, not N .create calls — see
      # kos/decisions/rails-orm-performance-n-plus-one-and-indexes.md
      ChecklistItem.insert_all(rows)
    end

    def rollback
      context.employee.checklist_items.onboarding.delete_all
    end
  end
end
