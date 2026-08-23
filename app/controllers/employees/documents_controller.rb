module Employees
  class DocumentsController < ApplicationController
    def create
      employee = policy_scope(Employee).find(params[:employee_id])
      authorize employee, :update?

      document = employee.documents.new(document_params)
      document.uploaded_by = current_employee

      if document.save
        redirect_to employee_path(employee), notice: "Document uploaded."
      else
        redirect_to employee_path(employee), alert: document.errors.full_messages.to_sentence
      end
    end

    private

    def document_params
      params.require(:document).permit(:title, :category, :file)
    end
  end
end
