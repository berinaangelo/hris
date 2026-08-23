class RolesAccessController < ApplicationController
  def index
    authorize Employee, :index?
    @employees = policy_scope(Employee).order(:last_name)
  end

  def edit
    @employee = policy_scope(Employee).find(params[:id])
    authorize @employee, :assign_role?
  end

  def update
    @employee = policy_scope(Employee).find(params[:id])
    authorize @employee, :assign_role?

    result = Employees::AssignRole.call(employee: @employee, role: params[:employee][:role])

    if result.success?
      redirect_to roles_access_index_path, notice: "#{@employee.full_name}'s access level updated."
    else
      flash.now[:alert] = result.message
      render :edit, status: :unprocessable_entity
    end
  end
end
