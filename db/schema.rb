# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_23_130013) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "attendance_correction_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "attendance_record_id"
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.bigint "employee_id", null: false
    t.text "reason", null: false
    t.datetime "requested_clock_in_at"
    t.datetime "requested_clock_out_at"
    t.datetime "reviewed_at"
    t.bigint "reviewed_by_id"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["attendance_record_id"], name: "index_attendance_correction_requests_on_attendance_record_id"
    t.index ["employee_id"], name: "index_attendance_correction_requests_on_employee_id"
    t.index ["reviewed_by_id"], name: "index_attendance_correction_requests_on_reviewed_by_id"
    t.index ["status", "employee_id"], name: "index_attendance_correction_requests_on_status_and_employee_id"
  end

  create_table "attendance_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "clock_in_at"
    t.datetime "clock_out_at"
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.integer "edit_approval_status", default: 0, null: false
    t.datetime "edit_approved_at"
    t.bigint "edit_approved_by_id"
    t.datetime "edited_at"
    t.bigint "edited_by_id"
    t.bigint "employee_id", null: false
    t.boolean "manually_edited", default: false, null: false
    t.bigint "shift_template_id", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_attendance_records_on_date"
    t.index ["edit_approved_by_id"], name: "index_attendance_records_on_edit_approved_by_id"
    t.index ["edited_by_id"], name: "index_attendance_records_on_edited_by_id"
    t.index ["employee_id", "date"], name: "index_attendance_records_on_employee_id_and_date", unique: true
    t.index ["employee_id", "status"], name: "index_attendance_records_on_employee_id_and_status"
    t.index ["employee_id"], name: "index_attendance_records_on_employee_id"
    t.index ["shift_template_id"], name: "index_attendance_records_on_shift_template_id"
  end

  create_table "benefit_dependents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "benefit_enrollment_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "relationship", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_enrollment_id"], name: "index_benefit_dependents_on_benefit_enrollment_id"
  end

  create_table "benefit_enrollments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "effectivity_date", null: false
    t.bigint "employee_id", null: false
    t.string "plan_name", null: false
    t.string "provider", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_benefit_enrollments_on_employee_id"
  end

  create_table "certifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "cert_name", null: false
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.date "expiry_date", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_certifications_on_employee_id"
    t.index ["expiry_date"], name: "index_certifications_on_expiry_date"
  end

  create_table "checklist_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "checklist_type", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.string "item_key", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "checklist_type", "item_key"], name: "index_checklist_items_on_employee_and_key", unique: true
    t.index ["employee_id", "checklist_type"], name: "index_checklist_items_on_employee_id_and_checklist_type"
    t.index ["employee_id"], name: "index_checklist_items_on_employee_id"
  end

  create_table "companies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "attendance_approvers_enabled", default: false, null: false
    t.boolean "attendance_manual_edit_enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.boolean "thirteenth_month_pay_enabled", default: true, null: false
    t.string "timezone", default: "Asia/Manila", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "category", default: 3, null: false
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "uploaded_by_id"
    t.index ["employee_id"], name: "index_documents_on_employee_id"
    t.index ["uploaded_by_id"], name: "index_documents_on_uploaded_by_id"
  end

  create_table "employees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "birthdate"
    t.boolean "company_announcement_notifications", default: true, null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "department", null: false
    t.string "emergency_contact_name"
    t.string "emergency_contact_phone"
    t.string "employee_number", null: false
    t.integer "employment_type", default: 0, null: false
    t.string "first_name", null: false
    t.string "home_address"
    t.string "job_title", null: false
    t.datetime "last_login_at"
    t.string "last_name", null: false
    t.date "last_working_day"
    t.boolean "leave_request_updates_notifications", default: true, null: false
    t.integer "lock_version", default: 0, null: false
    t.bigint "manager_id"
    t.string "mobile_number"
    t.boolean "new_payslip_notifications", default: true, null: false
    t.text "offboarding_notes"
    t.string "offboarding_reason"
    t.datetime "password_changed_at"
    t.string "password_digest", null: false
    t.string "personal_email"
    t.boolean "rehire_eligible"
    t.boolean "review_cycle_notifications", default: true, null: false
    t.integer "role", default: 0, null: false
    t.bigint "shift_template_id"
    t.date "start_date", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "work_email", null: false
    t.index ["company_id", "employee_number"], name: "index_employees_on_company_id_and_employee_number", unique: true
    t.index ["company_id", "role"], name: "index_employees_on_company_id_and_role"
    t.index ["company_id", "status"], name: "index_employees_on_company_id_and_status"
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["manager_id"], name: "index_employees_on_manager_id"
    t.index ["shift_template_id"], name: "index_employees_on_shift_template_id"
    t.index ["work_email"], name: "index_employees_on_work_email", unique: true
  end

  create_table "job_candidates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "applied_at", null: false
    t.datetime "consent_given_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "full_name", null: false
    t.bigint "hired_employee_id"
    t.bigint "job_opening_id", null: false
    t.text "note"
    t.string "phone"
    t.integer "stage", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["hired_employee_id"], name: "index_job_candidates_on_hired_employee_id"
    t.index ["job_opening_id", "stage"], name: "index_job_candidates_on_job_opening_id_and_stage"
    t.index ["job_opening_id"], name: "index_job_candidates_on_job_opening_id"
  end

  create_table "job_openings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "status"], name: "index_job_openings_on_company_id_and_status"
    t.index ["company_id"], name: "index_job_openings_on_company_id"
    t.index ["slug"], name: "index_job_openings_on_slug", unique: true
  end

  create_table "kpi_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "actual"
    t.text "comment"
    t.datetime "created_at", null: false
    t.string "kpi_name", null: false
    t.integer "position", null: false
    t.bigint "review_cycle_id", null: false
    t.integer "score"
    t.string "target", null: false
    t.datetime "updated_at", null: false
    t.index ["review_cycle_id"], name: "index_kpi_entries_on_review_cycle_id"
  end

  create_table "leave_balances", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.decimal "entitled_days", precision: 5, scale: 2, default: "0.0", null: false
    t.bigint "leave_type_id", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "updated_at", null: false
    t.decimal "used_days", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "year", null: false
    t.index ["employee_id", "leave_type_id", "year"], name: "index_leave_balances_on_employee_type_year", unique: true
    t.index ["employee_id"], name: "index_leave_balances_on_employee_id"
    t.index ["leave_type_id"], name: "index_leave_balances_on_leave_type_id"
  end

  create_table "leave_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "approver_id"
    t.datetime "created_at", null: false
    t.decimal "days_requested", precision: 5, scale: 2, null: false
    t.datetime "decided_at"
    t.text "decision_note"
    t.bigint "employee_id", null: false
    t.date "end_date", null: false
    t.bigint "leave_type_id", null: false
    t.text "reason"
    t.date "start_date", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["approver_id", "status"], name: "index_leave_requests_on_approver_id_and_status"
    t.index ["approver_id"], name: "index_leave_requests_on_approver_id"
    t.index ["employee_id", "start_date", "end_date"], name: "idx_on_employee_id_start_date_end_date_d02df186b8"
    t.index ["employee_id"], name: "index_leave_requests_on_employee_id"
    t.index ["leave_type_id"], name: "index_leave_requests_on_leave_type_id"
    t.index ["status"], name: "index_leave_requests_on_status"
  end

  create_table "leave_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "name"], name: "index_leave_types_on_company_id_and_name", unique: true
    t.index ["company_id"], name: "index_leave_types_on_company_id"
  end

  create_table "loans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.integer "loan_type", null: false
    t.decimal "monthly_amortization", precision: 10, scale: 2, null: false
    t.integer "remaining_installments", null: false
    t.integer "status", default: 0, null: false
    t.decimal "total_amount", precision: 12, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "status"], name: "index_loans_on_employee_id_and_status"
    t.index ["employee_id"], name: "index_loans_on_employee_id"
  end

  create_table "payroll_runs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "finalized_at"
    t.bigint "finalized_by_id"
    t.date "pay_date", null: false
    t.date "period_end", null: false
    t.date "period_start", null: false
    t.integer "run_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "status"], name: "index_payroll_runs_on_company_id_and_status"
    t.index ["company_id"], name: "index_payroll_runs_on_company_id"
    t.index ["finalized_by_id"], name: "index_payroll_runs_on_finalized_by_id"
  end

  create_table "payslip_line_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "direction", null: false
    t.integer "line_type", null: false
    t.bigint "loan_id"
    t.bigint "payslip_id", null: false
    t.integer "source", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_id"], name: "index_payslip_line_items_on_loan_id"
    t.index ["payslip_id"], name: "index_payslip_line_items_on_payslip_id"
  end

  create_table "payslips", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "emailed_at"
    t.bigint "employee_id", null: false
    t.datetime "generated_at"
    t.bigint "generated_by_id"
    t.decimal "gross_pay", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "net_pay", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "payroll_run_id", null: false
    t.bigint "previous_version_id"
    t.integer "status", default: 0, null: false
    t.decimal "total_deductions", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.datetime "viewed_at"
    t.text "void_reason"
    t.index ["employee_id"], name: "index_payslips_on_employee_id"
    t.index ["generated_by_id"], name: "index_payslips_on_generated_by_id"
    t.index ["payroll_run_id", "employee_id"], name: "index_payslips_on_payroll_run_id_and_employee_id"
    t.index ["payroll_run_id"], name: "index_payslips_on_payroll_run_id"
    t.index ["previous_version_id"], name: "index_payslips_on_previous_version_id"
    t.index ["status"], name: "index_payslips_on_status"
  end

  create_table "rate_tables", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "agency", null: false
    t.json "brackets"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.date "effective_date", null: false
    t.json "fields"
    t.datetime "updated_at", null: false
    t.bigint "updated_by_id"
    t.index ["company_id", "agency"], name: "index_rate_tables_on_company_id_and_agency", unique: true
    t.index ["company_id"], name: "index_rate_tables_on_company_id"
    t.index ["updated_by_id"], name: "index_rate_tables_on_updated_by_id"
  end

  create_table "review_cycles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "cycle_type", default: 0, null: false
    t.bigint "employee_id", null: false
    t.date "end_date", null: false
    t.text "manager_comment"
    t.integer "outcome"
    t.datetime "published_at"
    t.date "start_date", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "cycle_type", "status"], name: "index_review_cycles_on_employee_type_status"
    t.index ["employee_id"], name: "index_review_cycles_on_employee_id"
    t.index ["status"], name: "index_review_cycles_on_status"
  end

  create_table "shift_templates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.time "end_time", null: false
    t.string "name", null: false
    t.time "start_time", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_shift_templates_on_company_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attendance_correction_requests", "attendance_records"
  add_foreign_key "attendance_correction_requests", "employees"
  add_foreign_key "attendance_correction_requests", "employees", column: "reviewed_by_id"
  add_foreign_key "attendance_records", "employees"
  add_foreign_key "attendance_records", "employees", column: "edit_approved_by_id"
  add_foreign_key "attendance_records", "employees", column: "edited_by_id"
  add_foreign_key "attendance_records", "shift_templates"
  add_foreign_key "benefit_dependents", "benefit_enrollments"
  add_foreign_key "benefit_enrollments", "employees"
  add_foreign_key "certifications", "employees"
  add_foreign_key "checklist_items", "employees"
  add_foreign_key "documents", "employees"
  add_foreign_key "documents", "employees", column: "uploaded_by_id"
  add_foreign_key "employees", "companies"
  add_foreign_key "employees", "employees", column: "manager_id"
  add_foreign_key "employees", "shift_templates"
  add_foreign_key "job_candidates", "employees", column: "hired_employee_id"
  add_foreign_key "job_candidates", "job_openings"
  add_foreign_key "job_openings", "companies"
  add_foreign_key "kpi_entries", "review_cycles"
  add_foreign_key "leave_balances", "employees"
  add_foreign_key "leave_balances", "leave_types"
  add_foreign_key "leave_requests", "employees"
  add_foreign_key "leave_requests", "employees", column: "approver_id"
  add_foreign_key "leave_requests", "leave_types"
  add_foreign_key "leave_types", "companies"
  add_foreign_key "loans", "employees"
  add_foreign_key "payroll_runs", "companies"
  add_foreign_key "payroll_runs", "employees", column: "finalized_by_id"
  add_foreign_key "payslip_line_items", "loans"
  add_foreign_key "payslip_line_items", "payslips"
  add_foreign_key "payslips", "employees"
  add_foreign_key "payslips", "employees", column: "generated_by_id"
  add_foreign_key "payslips", "payroll_runs"
  add_foreign_key "payslips", "payslips", column: "previous_version_id"
  add_foreign_key "rate_tables", "companies"
  add_foreign_key "rate_tables", "employees", column: "updated_by_id"
  add_foreign_key "review_cycles", "employees"
  add_foreign_key "shift_templates", "companies"
end
