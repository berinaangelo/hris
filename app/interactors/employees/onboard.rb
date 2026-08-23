module Employees
  # Mirrors the exact shape in
  # kos/decisions/rails-thin-controllers-organizer-interactor-pattern.md
  class Onboard
    include Interactor::Organizer

    organize Employees::CreateRecord, Employees::AttachOnboardingChecklist
  end
end
