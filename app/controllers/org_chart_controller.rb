class OrgChartController < ApplicationController
  def show
    authorize :org_chart, :show?

    employees = current_employee.company.employees.where.not(status: :offboarded).includes(:manager)
    @roots = employees.select { |e| e.manager_id.nil? }
    @reports_by_manager_id = employees.group_by(&:manager_id)
    @headcount = employees.size
    @department_count = employees.map(&:department).uniq.size
  end
end
