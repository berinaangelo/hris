class AddAttendanceEditApprovalNotificationsToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :attendance_edit_approval_notifications, :boolean, null: false, default: true
  end
end
