module Employees
  class ChecklistItemsController < ApplicationController
    def complete
      employee = policy_scope(Employee).find(params[:employee_id])
      authorize employee, :update?

      employee.checklist_items.find(params[:id]).complete!
      redirect_to employee_path(employee), notice: "Marked done."
    end
  end
end
