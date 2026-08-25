# Derives an employee's current review state from their most recent
# review cycle (loaded association, no extra query) — used by Team
# Reviews and Company Reviews rosters. See
# kos/decisions/rails-presenters-decorators-for-view-formatting.md.
class ReviewStatusPresenter
  def initialize(employee)
    @employee = employee
    @current_cycle = employee.review_cycles.max_by(&:start_date)
    @earlier_cycles = employee.review_cycles.sort_by(&:start_date).reverse - [ @current_cycle ]
  end

  # A bulk-opened "shell" cycle (see ReviewCycles::OpenCycle's
  # company-wide/department callers) has no KPIs yet until a manager
  # attaches them (ReviewCycles::AttachKpiEntries). Without this state,
  # such a cycle would otherwise read as "Needs scoring" once its end
  # date passes despite having nothing to score — checked first in both
  # #label and #badge_category below so it always takes precedence.
  def awaiting_kpis?
    @current_cycle.present? && @current_cycle.kpi_entries.empty? && !@current_cycle.published?
  end

  def on_pip?
    @current_cycle&.pip? && @current_cycle.in_progress? &&
      Date.current.between?(@current_cycle.start_date, @current_cycle.end_date)
  end

  def needs_scoring?
    @current_cycle&.scoring_open? || false
  end

  def label
    return "Awaiting KPIs" if awaiting_kpis?
    return "On PIP" if on_pip?
    return "Needs scoring" if needs_scoring?
    return "In progress" if @current_cycle&.in_progress?
    return "#{@current_cycle.overall_rating.round(1)}/5" if @current_cycle&.published? && @current_cycle.overall_rating

    "Not started"
  end

  # "On PIP" is Caution on Team Reviews but Negative on Company Reviews
  # — each page's own UI decision doc specifies a different color for
  # the same status, so the scope is passed in rather than baked into
  # the shared BadgePresenter's flat status->category table.
  def badge_category(scope: :team)
    return :neutral if awaiting_kpis?
    return (scope == :company ? :negative : :caution) if on_pip?
    return :caution if needs_scoring? || @current_cycle&.in_progress?
    return :neutral if @current_cycle.nil?

    nil # published, steady state — no badge
  end

  # The employee's most recently *published* cycle before the current
  # one — context for On PIP / Needs Scoring rows on Company Reviews'
  # roster ("last: 4.3/5 · H1 2026"), per
  # kos/decisions/ui/company-reviews-roster-filterable-grid-list.md. Nil
  # when there's no prior published cycle with a rating.
  def previous_rating
    previous_cycle = @earlier_cycles.find { |cycle| cycle.published? && cycle.overall_rating }
    return nil unless previous_cycle

    { rating: previous_cycle.overall_rating.round(1), period_label: half_year_label(previous_cycle.start_date) }
  end

  private

  def half_year_label(date)
    "H#{date.month <= 6 ? 1 : 2} #{date.year}"
  end
end
