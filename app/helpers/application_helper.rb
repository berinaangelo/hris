module ApplicationHelper
  # "Good morning/afternoon/evening, {first name}" for the Home
  # dashboard greeting — see kos/decisions/ui/home-dashboard-balance-led-hero.md.
  def time_of_day_greeting(employee)
    period = case Time.current.hour
    when 5...12 then "morning"
    when 12...18 then "afternoon"
    else "evening"
    end
    "Good #{period}, #{employee.first_name}"
  end
end
