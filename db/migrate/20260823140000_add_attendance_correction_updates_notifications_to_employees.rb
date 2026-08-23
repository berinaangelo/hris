class AddAttendanceCorrectionUpdatesNotificationsToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :attendance_correction_updates_notifications, :boolean, null: false, default: true
  end
end
