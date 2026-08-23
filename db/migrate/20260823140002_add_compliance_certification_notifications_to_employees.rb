class AddComplianceCertificationNotificationsToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :compliance_certification_notifications, :boolean, default: true, null: false
  end
end
