module Employees
  class MarkOffboarded
    include Interactor

    def call
      employee = context.employee

      unless employee.offboarding?
        context.fail!(message: "This employee isn't in the offboarding process.")
        return
      end

      unless employee.last_working_day&.past?
        context.fail!(message: "The last working day hasn't passed yet.")
        return
      end

      offboarding_items = employee.checklist_items.offboarding
      unless offboarding_items.count == Employee::OFFBOARDING_ITEM_KEYS.size && offboarding_items.all?(&:completed?)
        context.fail!(message: "All clearance items must be completed first.")
        return
      end

      employee.update!(status: :offboarded)
    end
  end
end
