module Employees
  class CreateRecord
    include Interactor

    def call
      employee = Employee.new(context.employee_params)
      employee.company = context.company
      employee.employee_number = next_employee_number(context.company)

      # Set on context even on failure — the controller re-renders :new
      # with this exact (unsaved, validated) instance so per-field
      # errors show inline, same fix as Leave::SubmitRequest's own
      # failure path (see hris-batch2-ux-pass-me-tab memory).
      context.employee = employee

      unless employee.save
        context.fail!(message: employee.errors.full_messages.to_sentence)
      end
    end

    def rollback
      context.employee&.destroy
    end

    private

    # Not a form field — the Add Employee mockup's own field list has no
    # employee-number input, this is system-generated. See
    # kos/decisions/ui/add-employee-split-live-preview.md.
    def next_employee_number(company)
      last_sequence = company.employees.pluck(:employee_number).filter_map { |n| n[/\d+/]&.to_i }.max || 0
      format("EMP-%04d", last_sequence + 1)
    end
  end
end
