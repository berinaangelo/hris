class AddBasicSalaryToEmployees < ActiveRecord::Migration[8.1]
  def change
    # Monthly base salary — payroll v2 prorates this per semi-monthly
    # cutoff (see kos/decisions/schema/payroll-v2-schema.md). Nullable:
    # presence is enforced at payroll-run-open time (Payroll::OpenRun),
    # not the DB, so onboarding an employee doesn't require it upfront.
    add_column :employees, :basic_salary, :decimal, precision: 10, scale: 2
  end
end
