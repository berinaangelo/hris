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
  employment_type: :full_time, start_date: 1.year.ago.to_date,
  mobile_number: "+639171234567", home_address: "123 Makati Ave, Makati City")

paolo = find_or_build_employee(company, "EMP-0044",
  first_name: "Paolo", last_name: "Villanueva", work_email: "paolo.villanueva@alonpay.ph",
  manager: ramon, role: :employee, job_title: "Backend Engineer", department: "Engineering",
  employment_type: :full_time, start_date: 1.year.ago.to_date)

isabel = find_or_build_employee(company, "EMP-0057",
  first_name: "Isabel", last_name: "Torres", work_email: "isabel.torres@alonpay.ph",
  manager: ferdinand, role: :employee, job_title: "Accountant", department: "Finance",
  employment_type: :full_time, start_date: 1.year.ago.to_date)

miguel = find_or_build_employee(company, "EMP-0021",
  first_name: "Miguel", last_name: "Santos", work_email: "miguel.santos@alonpay.ph",
  manager: andrea, role: :manager, job_title: "Sales Lead", department: "Sales",
  employment_type: :full_time, start_date: 2.years.ago.to_date)

bea = find_or_build_employee(company, "EMP-0033",
  first_name: "Bea", last_name: "Fernandez", work_email: "bea.fernandez@alonpay.ph",
  manager: miguel, role: :employee, job_title: "Sales Associate", department: "Sales",
  employment_type: :full_time, start_date: 1.year.ago.to_date)

carlo = find_or_build_employee(company, "EMP-0058",
  first_name: "Carlo", last_name: "Bautista", work_email: "carlo.bautista@alonpay.ph",
  manager: ramon, role: :employee, job_title: "Backend Engineer", department: "Engineering",
  employment_type: :full_time, start_date: 1.year.ago.to_date)

diego = find_or_build_employee(company, "EMP-0059",
  first_name: "Diego", last_name: "Reyes", work_email: "diego.reyes@alonpay.ph",
  manager: ramon, role: :employee, job_title: "Frontend Engineer", department: "Engineering",
  employment_type: :full_time, start_date: 1.year.ago.to_date)

grace = find_or_build_employee(company, "EMP-0060",
  first_name: "Grace", last_name: "Lim", work_email: "grace.lim@alonpay.ph",
  manager: ramon, role: :employee, job_title: "Product Designer", department: "Design",
  employment_type: :full_time, start_date: 1.year.ago.to_date)

# An in-progress Offboarding example — last working day still in the
# future, some but not all clearance items done — so the Offboarding UI
# has a non-active row to show without manually triggering the flow
# first, per kos/decisions/ui/offboarding-flow-schedule-clearance-tracker.md.
jonas = find_or_build_employee(company, "EMP-0089",
  first_name: "Jonas", last_name: "Rivera", work_email: "jonas.rivera@alonpay.ph",
  manager: ramon, role: :employee, job_title: "QA Engineer", department: "Engineering",
  employment_type: :full_time, start_date: 1.year.ago.to_date,
  status: :offboarding, last_working_day: 10.days.from_now.to_date,
  offboarding_reason: "Resigned — pursuing an opportunity abroad")

Employee::OFFBOARDING_ITEM_KEYS.each_with_index do |key, index|
  item = ChecklistItem.find_or_create_by!(employee: jonas, checklist_type: :offboarding, item_key: key) do |ci|
    ci.position = index
  end
  item.complete! if index < 2 && !item.completed?
end

# Every seeded employee gets the onboarding checklist too — they were
# never run through Employees::Onboard (that interactor is only
# exercised via the real Add Employee flow), so without this the
# Onboarding Checklist card is empty for all of them. Fully done for
# everyone except Mikaela, who's the running "still has a pending item"
# example already used across the kos/ mockups.
all_employees = [andrea, ramon, ferdinand, mikaela, paolo, isabel, miguel, bea, carlo, diego, grace, jonas]
all_employees.each do |employee|
  Employee::ONBOARDING_ITEM_KEYS.each_with_index do |key, index|
    item = ChecklistItem.find_or_create_by!(employee: employee, checklist_type: :onboarding, item_key: key) do |ci|
      ci.position = index
    end
    leave_pending = employee == mikaela && key == "company_equipment_issued"
    item.complete! if !leave_pending && !item.completed?
  end
end

leave_types = ["Vacation", "Sick", "Emergency", "Others"].map do |name|
  LeaveType.find_or_create_by!(company: company, name: name)
end
vacation = leave_types.first

all_employees.each do |employee|
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

# Review cycles in three different states, so My/Team/Company Reviews
# and the bulk cycle-open flow all have something to show without
# manually creating data first: Paolo's is published and scored,
# Carlo's is awaiting scoring, and Diego's is a KPI-less "shell" — as
# if HR bulk-opened it and Ramon (his manager) hasn't attached KPIs
# yet, per company-reviews-roster-filterable-grid-list.md.
paolo_cycle = ReviewCycle.find_or_create_by!(employee: paolo, cycle_type: :regular, start_date: 8.months.ago.to_date) do |c|
  c.end_date = 2.months.ago.to_date
  c.status = :published
  c.published_at = 2.months.ago
  c.manager_comment = "Consistently ships clean, well-tested code."
end
if paolo_cycle.kpi_entries.none?
  paolo_cycle.kpi_entries.create!([
    { kpi_name: "Ship the v2 payments API", target: "Launched with no P1 bugs", actual: "Shipped 3 days early", score: 5, position: 1 },
    { kpi_name: "Code review turnaround", target: "Under 24h median", actual: "18h median", score: 4, position: 2 },
    { kpi_name: "Mentor a junior engineer", target: "Weekly 1:1s for the quarter", actual: "Held all sessions", score: 5, position: 3 }
  ])
end

carlo_cycle = ReviewCycle.find_or_create_by!(employee: carlo, cycle_type: :regular, start_date: 6.months.ago.to_date) do |c|
  c.end_date = 1.day.ago.to_date
  c.status = :awaiting_scoring
end
if carlo_cycle.kpi_entries.none?
  carlo_cycle.kpi_entries.create!([
    { kpi_name: "Reduce API error rate", target: "Under 0.5%", position: 1 },
    { kpi_name: "Ship the notifications service", target: "Launched by end of cycle", position: 2 },
    { kpi_name: "On-call response time", target: "Under 15 min median", position: 3 }
  ])
end

ReviewCycle.find_or_create_by!(employee: diego, cycle_type: :regular, start_date: 1.month.ago.to_date) do |c|
  c.end_date = 5.months.from_now.to_date
  c.status = :in_progress
end

# A finalized payroll run so Payroll Register / Statutory
# Contributions Summary (Reports) have something to show.
payroll_run = PayrollRun.find_or_create_by!(
  company: company, period_start: 1.month.ago.beginning_of_month.to_date, period_end: 1.month.ago.end_of_month.to_date
) do |run|
  run.run_type = :regular
  run.status = :finalized
  run.pay_date = 1.month.ago.end_of_month.to_date + 5.days
  run.finalized_at = 1.month.ago.end_of_month
  run.finalized_by = andrea
end

{ mikaela => 45_000, paolo => 55_000, carlo => 50_000 }.each do |employee, base_salary|
  next if payroll_run.payslips.exists?(employee: employee)

  sss = (base_salary * 0.045).round(2)
  philhealth = (base_salary * 0.02).round(2)
  pagibig = 200.0
  deductions = sss + philhealth + pagibig

  payslip = payroll_run.payslips.create!(
    employee: employee, status: :finalized, gross_pay: base_salary,
    total_deductions: deductions, net_pay: base_salary - deductions,
    generated_at: payroll_run.finalized_at, generated_by: andrea
  )
  payslip.payslip_line_items.create!([
    { line_type: :base_salary, direction: :earning, source: :base, amount: base_salary },
    { line_type: :statutory_sss, direction: :deduction, source: :statutory, amount: sss },
    { line_type: :statutory_philhealth, direction: :deduction, source: :statutory, amount: philhealth },
    { line_type: :statutory_pagibig, direction: :deduction, source: :statutory, amount: pagibig }
  ])
end

# A benefit enrollment with a dependent, so Employee Detail's Benefits
# card isn't empty on first look.
mikaela_hmo = BenefitEnrollment.find_or_create_by!(employee: mikaela, plan_name: "Gold HMO", provider: "Maxicare") do |e|
  e.effectivity_date = 6.months.ago.to_date
end
mikaela_hmo.benefit_dependents.find_or_create_by!(name: "Anna Santos", relationship: :spouse)

# A job opening with a candidate at Offer (one click away from "Mark
# Hired" for testing the handoff) and one at New, so the kanban board
# isn't a single empty column.
data_analyst_opening = JobOpening.find_or_create_by!(company: company, title: "Data Analyst") do |jo|
  jo.description = "Join Finance to help Alon Pay make sense of its own numbers."
  jo.status = :open
end

JobCandidate.find_or_create_by!(job_opening: data_analyst_opening, email: "emilio.aguinaldo@example.com") do |c|
  c.full_name = "Emilio Aguinaldo"
  c.phone = "+639171112222"
  c.stage = :offer
  c.applied_at = 2.weeks.ago
  c.consent_given_at = 2.weeks.ago
  c.note = "Strong SQL round, references check out."
end

JobCandidate.find_or_create_by!(job_opening: data_analyst_opening, email: "melchora.aquino@example.com") do |c|
  c.full_name = "Melchora Aquino"
  c.stage = :submitted
  c.applied_at = 3.days.ago
  c.consent_given_at = 3.days.ago
end

puts "Seeded #{Employee.count} employees at #{company.name}. Demo password: #{DEMO_PASSWORD}"
puts "Try andrea.cruz@alonpay.ph (admin), ramon.delacruz@alonpay.ph (manager), mikaela.santos@alonpay.ph (employee)."
puts "Also seeded: a published + an awaiting-scoring + a KPI-less shell review cycle, a finalized payroll run, " \
     "a benefit enrollment, and a job opening with two candidates (one at Offer, ready to Mark Hired)."
