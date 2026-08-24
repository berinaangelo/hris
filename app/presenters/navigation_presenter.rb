# Single source of truth for the Me/Team/Company top nav + its section
# sidebar — see kos/decisions/ui/navigation-me-team-company.md. Pure
# PORO like the other presenters (badge_presenter.rb etc.) — no
# view_context, the view resolves `path_helper` symbols itself.
class NavigationPresenter
  NavItem = Struct.new(:section, :label, :icon, :path_helper, :http_method, :controller_paths, :count_proc,
                        keyword_init: true) do
    def matches?(request_controller_path)
      Array(controller_paths).any? do |path|
        request_controller_path == path || request_controller_path.start_with?("#{path}/")
      end
    end
  end

  Tab = Struct.new(:label, :path_helper, :active, :count, keyword_init: true)
  SidebarItem = Struct.new(:label, :icon, :path_helper, :http_method, :count, :active, keyword_init: true)

  SECTION_LABELS = { me: "Me", team: "Team", company: "Company" }.freeze

  # Where clicking the top-level pill itself lands, independent of item
  # order below.
  SECTION_LANDING_PATH_HELPER = { me: :root_path, team: :team_approvals_path, company: :employees_path }.freeze

  SECTION_GATES = {
    me: ->(employee) { true },
    team: ->(employee) { employee.manager? || employee.admin? },
    company: ->(employee) { employee.admin? }
  }.freeze

  ITEMS = [
    NavItem.new(section: :me, label: "Home", icon: :grid, path_helper: :root_path,
                controller_paths: "dashboard"),
    NavItem.new(section: :me, label: "Time Off", icon: :calendar, path_helper: :leave_requests_path,
                controller_paths: "leave_requests"),
    NavItem.new(section: :me, label: "Attendance", icon: :clock, path_helper: :attendance_correction_requests_path,
                controller_paths: "attendance_correction_requests"),
    NavItem.new(section: :me, label: "My Reviews", icon: :"trending-up", path_helper: :review_cycles_path,
                controller_paths: "review_cycles"),
    NavItem.new(section: :me, label: "My Profile", icon: :user, path_helper: :my_profile_path,
                controller_paths: "my_profile"),
    NavItem.new(section: :me, label: "My Payslips", icon: :file, path_helper: :payslips_path,
                controller_paths: "payslips"),
    NavItem.new(section: :me, label: "Account Settings", icon: :settings, path_helper: :account_settings_path,
                controller_paths: ""),
    NavItem.new(section: :me, label: "Sign out", icon: :"log-out", path_helper: :session_path,
                http_method: :delete, controller_paths: ""),

    NavItem.new(section: :team, label: "Approvals", icon: :"check-circle", path_helper: :team_approvals_path,
                controller_paths: "team/approvals",
                count_proc: ->(employee) { LeaveRequests::PendingForApprover.call(employee).count }),
    NavItem.new(section: :team, label: "Team Calendar", icon: :calendar, path_helper: :team_calendar_path,
                controller_paths: "team/calendar"),
    NavItem.new(section: :team, label: "Team Reviews", icon: :"trending-up", path_helper: :team_review_cycles_path,
                controller_paths: "team/review_cycles"),
    NavItem.new(section: :team, label: "Team Attendance", icon: :clock, path_helper: :team_attendance_records_path,
                controller_paths: "team/attendance_records",
                count_proc: ->(employee) { AttendanceCorrectionRequests::PendingForApprover.call(employee).count }),

    NavItem.new(section: :company, label: "People", icon: :users, path_helper: :employees_path,
                controller_paths: "employees"),
    NavItem.new(section: :company, label: "Org Chart", icon: :network, path_helper: :org_chart_path,
                controller_paths: "org_chart"),
    NavItem.new(section: :company, label: "Attendance Sign-offs", icon: :"shield-check",
                path_helper: :team_attendance_edit_approvals_path,
                controller_paths: "team/attendance_edit_approvals",
                count_proc: ->(employee) { AttendanceRecords::PendingApproverSignoff.call(employee).count }),
    NavItem.new(section: :company, label: "Compliance", icon: :"circle-check", path_helper: :certifications_path,
                controller_paths: "certifications"),
    NavItem.new(section: :company, label: "Payroll", icon: :banknote, path_helper: :payroll_runs_path,
                controller_paths: "payroll_runs"),
    NavItem.new(section: :company, label: "Rate Tables", icon: :list, path_helper: :rate_tables_path,
                controller_paths: "rate_tables"),
    NavItem.new(section: :company, label: "Payroll Settings", icon: :settings, path_helper: :payroll_settings_path,
                controller_paths: "payroll_settings"),
    NavItem.new(section: :company, label: "Performance Reviews", icon: :"trending-up",
                path_helper: :company_review_cycles_path, controller_paths: "company_review_cycles"),
    NavItem.new(section: :company, label: "Reports", icon: :grid, path_helper: :reports_path,
                controller_paths: "reports"),
    NavItem.new(section: :company, label: "Job Openings", icon: :briefcase, path_helper: :job_openings_path,
                controller_paths: %w[job_openings job_candidates]),
    NavItem.new(section: :company, label: "Roles & Access", icon: :lock, path_helper: :roles_access_index_path,
                controller_paths: "roles_access")
  ].freeze

  # section_override lets a controller whose action serves two different
  # sections under one controller path (PayslipsController#show is both
  # self-service "My Payslips" and an HR-admin drill-in from Payroll —
  # see payslips_controller.rb) force the correct section instead of the
  # generic controller-path match picking the wrong one.
  def initialize(current_employee:, request_controller_path:, section_override: nil)
    @employee = current_employee
    @request_controller_path = request_controller_path
    @section_override = section_override
    @counts = {}
  end

  def tabs
    visible_sections.map do |section|
      Tab.new(
        label: SECTION_LABELS.fetch(section),
        path_helper: SECTION_LANDING_PATH_HELPER.fetch(section),
        active: section == current_section,
        count: items_for(section).sum { |item| count_for(item) }
      )
    end
  end

  def sidebar_items
    return [] unless current_section

    items_for(current_section).map do |item|
      SidebarItem.new(
        label: item.label,
        icon: item.icon,
        path_helper: item.path_helper,
        http_method: item.http_method || :get,
        count: count_for(item),
        active: item.matches?(@request_controller_path)
      )
    end
  end

  def current_section
    @section_override || ITEMS.find { |item| item.matches?(@request_controller_path) }&.section
  end

  private

  def visible_sections
    SECTION_LABELS.keys.select { |section| SECTION_GATES.fetch(section).call(@employee) }
  end

  def items_for(section)
    ITEMS.select { |item| item.section == section }
  end

  def count_for(item)
    return 0 unless item.count_proc

    @counts[item.label] ||= item.count_proc.call(@employee)
  end
end
