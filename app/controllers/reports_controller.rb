require "csv"

# Basic Reporting — a fixed set of aggregate report views over data the
# app already collects, with CSV export. No report builder, no
# dashboard configuration — see kos/projects/hris/features/basic-reporting/PLAN.md
# and kos/decisions/ui/reports-landing-grid-drill-in.md.
class ReportsController < ApplicationController
  REPORT_DEFINITIONS = {
    "headcount-snapshot" => {
      title: "Headcount Snapshot", group: "People & Leave", query: Reports::HeadcountSnapshot,
      filter: :as_of, department_filter: true, icon: :users,
      description: "Active employees by department, as of today.",
      csv_headers: %w[Department Headcount]
    },
    "new-hires-vs-departures" => {
      title: "New Hires vs. Departures", group: "People & Leave", query: Reports::NewHiresVsDepartures,
      filter: :date_range, icon: :"user-minus",
      description: "New hires and departures by department, over a selected period.",
      csv_headers: [ "Department", "New Hires", "Departures" ]
    },
    "turnover-count" => {
      title: "Turnover Count", group: "People & Leave", query: Reports::TurnoverCount,
      filter: :date_range, department_filter: true, icon: :repeat,
      description: "Departures over a period, by department — raw count, not a rate.",
      csv_headers: %w[Department Departures]
    },
    "leave-balances" => {
      title: "Leave Balances", group: "People & Leave", query: Reports::LeaveBalances,
      filter: :as_of_year, department_filter: true, icon: :ledger,
      description: "Entitled, used, and remaining leave credits, per employee.",
      csv_headers: [ "Employee", "Department", "Leave Type", "Entitled", "Used", "Remaining" ]
    },
    "leave-taken-summary" => {
      title: "Leave Taken Summary", group: "People & Leave", query: Reports::LeaveTakenSummary,
      filter: :date_range, department_filter: true, icon: :"calendar-check",
      description: "Total days taken per period, by department.",
      csv_headers: [ "Department", "Days Taken" ]
    },
    "payroll-register" => {
      title: "Payroll Register", group: "Payroll", query: Reports::PayrollRegister,
      filter: :cutoff, department_filter: true, icon: :banknote,
      description: "Gross pay, deductions, and net pay per employee, per cutoff.",
      csv_headers: [ "Employee", "Department", "Gross Pay", "Total Deductions", "Net Pay" ]
    },
    "statutory-contributions-summary" => {
      title: "Statutory Contributions Summary", group: "Payroll", query: Reports::StatutoryContributionsSummary,
      filter: :cutoff, icon: :"bar-chart-flag",
      description: "Total SSS / PhilHealth / Pag-IBIG / BIR withheld per period.",
      csv_headers: %w[Contribution Amount]
    }
  }.freeze

  def index
    authorize :report, :index?
    @report_groups = REPORT_DEFINITIONS.group_by { |_key, definition| definition[:group] }
  end

  def show
    authorize :report, :show?
    @key = params[:id]
    @definition = REPORT_DEFINITIONS.fetch(@key) { raise ActiveRecord::RecordNotFound }
    @payroll_runs = PayrollRun.where(company: current_employee.company).order(period_start: :desc) if @definition[:filter] == :cutoff
    @departments = policy_scope(Employee).distinct.pluck(:department).compact.sort if @definition[:department_filter]
    @rows = @definition[:query].call(viewer: current_employee, **report_filters)

    respond_to do |format|
      format.html
      format.csv { send_data rows_to_csv, filename: "#{@key}-#{Date.current}.csv" }
    end
  end

  private

  def report_filters
    filters =
      case @definition[:filter]
      when :as_of then { as_of: parse_date(params[:as_of]) || Date.current }
      when :as_of_year then { year: params[:year].presence&.to_i || Date.current.year }
      when :date_range
        { start_date: parse_date(params[:start_date]) || 1.month.ago.to_date, end_date: parse_date(params[:end_date]) || Date.current }
      when :cutoff then { payroll_run_id: params[:payroll_run_id] }
      end

    filters[:department] = params[:department].presence if @definition[:department_filter]
    filters
  end

  def parse_date(value)
    Date.parse(value) if value.present?
  rescue ArgumentError
    nil
  end

  def rows_to_csv
    CSV.generate do |csv|
      csv << @definition[:csv_headers]
      @rows.each { |row| csv << row.values }
    end
  end
end
