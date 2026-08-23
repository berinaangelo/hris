class AddShiftTemplateToEmployees < ActiveRecord::Migration[8.1]
  def change
    # Nullable — not every company/employee uses shift attendance
    # (time-attendance is post-MVP, customer-dependent).
    add_reference :employees, :shift_template, null: true, foreign_key: true
  end
end
