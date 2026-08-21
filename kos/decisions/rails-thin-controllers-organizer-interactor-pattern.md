---
title: rails-thin-controllers-organizer-interactor-pattern
tags: [hris, rails, architecture, backend]
date: 2026-08-21
---

Carried over from the user's own established practice on past Rails
projects, to be followed once HRIS backend implementation starts (see
[[tech-stack-hotwire-over-coffeescript]] for the stack this applies
to): thin controllers, single-purpose Interactors, and an Organizer
that composes them into one named flow — using the `interactor` /
`interactor-rails` gem convention.

**The shape:**
- **Controller** — stays thin. Calls one Organizer, branches on
  `result.success?`. No business logic in the controller itself.
- **Interactor** — one class, one job (`include Interactor`), reads and
  writes off a shared `context` object, calls `context.fail!(message:)`
  to halt the chain. Optionally defines `rollback` to undo its own
  effect if a later step in the same organizer fails.
- **Organizer** — `include Interactor::Organizer`, declares the
  sequence of Interactors via `organize A, B, C`. No logic of its own —
  it's a named, reusable wrapper around "this whole flow," not a place
  business rules live. This is the "orchestrator" piece: DRY because
  each Interactor is reusable on its own or recomposed into a different
  Organizer elsewhere.

**Example** (Add Employee, from `kos/projects/hris/features` — see
People Directory / Employee Detail / Add Employee in
[[navigation-me-team-company]]):

```ruby
# app/controllers/employees_controller.rb
class EmployeesController < ApplicationController
  def create
    result = Employees::Onboard.call(employee_params: employee_params, manager_id: params[:manager_id])

    if result.success?
      redirect_to employee_path(result.employee), notice: "Employee added."
    else
      flash.now[:alert] = result.message
      render :new, status: :unprocessable_entity
    end
  end
end
```

```ruby
# app/interactors/employees/onboard.rb
module Employees
  class Onboard
    include Interactor::Organizer

    organize Employees::CreateRecord,
             Employees::AssignManager,
             Employees::AttachOnboardingChecklist,
             Employees::NotifyHR
  end
end
```

```ruby
# app/interactors/employees/create_record.rb
module Employees
  class CreateRecord
    include Interactor

    def call
      employee = Employee.new(context.employee_params)

      if employee.save
        context.employee = employee
      else
        context.fail!(message: employee.errors.full_messages.to_sentence)
      end
    end
  end
end
```

```ruby
# app/interactors/employees/assign_manager.rb
module Employees
  class AssignManager
    include Interactor

    def call
      manager = Employee.find_by(id: context.manager_id)
      context.fail!(message: "Manager not found") unless manager

      context.employee.update!(manager: manager)
    end

    # Organizer rolls back completed steps in reverse if a later one fails
    def rollback
      context.employee.update!(manager: nil)
    end
  end
end
```

Why this, not ad-hoc service objects with no shared convention: keeps
every controller action the same shape to read (thin, one call, branch
on success), and multi-step flows (like onboarding, which touches the
employee record, org position, and the onboarding checklist in one
"Add Employee" action) get automatic rollback on partial failure
without hand-rolled transaction/undo logic per feature.
