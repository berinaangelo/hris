class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :require_employee

  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  helper_method :current_employee

  private

  # Pundit's #authorize/#policy_scope call this to get the "user" a
  # policy is checked against — this app calls it current_employee
  # everywhere else, so point Pundit at the same method rather than
  # also defining current_user.
  def pundit_user
    current_employee
  end

  def current_employee
    @current_employee ||= Employee.find_by(id: session[:employee_id] || remembered_employee_id)
  end

  # Falls back to the "remember me" signed cookie (see
  # SessionsController#remember_or_forget) when there's no session —
  # e.g. the browser was closed and reopened.
  def remembered_employee_id
    return nil unless (id = cookies.signed[:employee_id])

    session[:employee_id] = id
    id
  end

  def require_employee
    redirect_to new_session_path, alert: "Please sign in." unless current_employee
  end

  def render_forbidden
    flash[:alert] = "You don't have access to that."
    redirect_back fallback_location: root_path
  end
end
