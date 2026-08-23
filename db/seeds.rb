# Personas match the ones already fixed across the kos/ mockups (People
# Directory, Org Chart, Team Approvals) so every screen can be checked
# against the already-decided HTML mockups instead of throwaway data.
# Idempotent — safe to run more than once.

company = Company.find_or_create_by!(name: "Alon Pay") do |c|
  c.timezone = "Asia/Manila"
end

DEMO_PASSWORD = "password123".freeze

def find_or_build_employee(company, employee_number, attrs)
  employee = Employee.find_or_initialize_by(company: company, employee_number: employee_number)
  employee.assign_attributes(attrs)
  employee.password = DEMO_PASSWORD if employee.new_record?
  employee.save!
  employee
end

andrea = find_or_build_employee(company, "EMP-0001",
  first_name: "Andrea", last_name: "Cruz", work_email: "andrea.cruz@alonpay.ph",
  role: :admin, job_title: "HR Head", department: "People", employment_type: :full_time,
  start_date: 3.years.ago.to_date)

ramon = find_or_build_employee(company, "EMP-0002",
  first_name: "Ramon", last_name: "Dela Cruz", work_email: "ramon.delacruz@alonpay.ph",
  manager: andrea, role: :manager, job_title: "Engineering Manager", department: "Engineering",
  employment_type: :full_time, start_date: 2.years.ago.to_date)

ferdinand = find_or_build_employee(company, "EMP-0003",
  first_name: "Ferdinand", last_name: "Ocampo", work_email: "ferdinand.ocampo@alonpay.ph",
  manager: andrea, role: :manager, job_title: "Finance Manager", department: "Finance",
  employment_type: :full_time, start_date: 2.years.ago.to_date)

mikaela = find_or_build_employee(company, "EMP-0142",
  first_name: "Mikaela", last_name: "Santos", work_email: "mikaela.santos@alonpay.ph",
  manager: ramon, role: :employee, job_title: "Product Designer", department: "Engineering",
  employment_type: :full_time, start_date: 1.year.ago.to_date)

paolo = find_or_build_employee(company, "EMP-0044",
  first_name: "Paolo", last_name: "Villanueva", work_email: "paolo.villanueva@alonpay.ph",
  manager: ramon, role: :employee, job_title: "Backend Engineer", department: "Engineering",
  employment_type: :full_time, start_date: 1.year.ago.to_date)

isabel = find_or_build_employee(company, "EMP-0057",
  first_name: "Isabel", last_name: "Torres", work_email: "isabel.torres@alonpay.ph",
  manager: ferdinand, role: :employee, job_title: "Accountant", department: "Finance",
  employment_type: :full_time, start_date: 1.year.ago.to_date)

leave_types = ["Vacation", "Sick", "Emergency", "Others"].map do |name|
  LeaveType.find_or_create_by!(company: company, name: name)
end
vacation = leave_types.first

[andrea, ramon, ferdinand, mikaela, paolo, isabel].each do |employee|
  LeaveBalance.find_or_create_by!(employee: employee, leave_type: vacation, year: Date.current.year) do |b|
    b.entitled_days = 15
    b.used_days = 2.5
  end
end

# A couple of requests already in flight, so Team Approvals / Home
# aren't empty on first login.
LeaveRequest.find_or_create_by!(employee: mikaela, leave_type: vacation, start_date: 3.days.from_now.to_date) do |r|
  r.approver = ramon
  r.end_date = 4.days.from_now.to_date
  r.days_requested = 2
  r.reason = "Family trip"
end

puts "Seeded #{Employee.count} employees at #{company.name}. Demo password: #{DEMO_PASSWORD}"
puts "Try andrea.cruz@alonpay.ph (admin), ramon.delacruz@alonpay.ph (manager), mikaela.santos@alonpay.ph (employee)."
