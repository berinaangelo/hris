---
title: rails-testing-minitest-factorybot-faker
tags: [hris, rails, backend, testing]
date: 2026-08-21
---

Standing testing conventions for the HRIS project.

**Framework: Minitest** — Rails' own built-in default (no RSpec DSL
added), fitting the project's general bias toward built-in defaults
over extra gems (same reasoning as
[[rails-activejob-solid-queue-for-background-work|Solid Queue over
Sidekiq]]).

**One test type per concern, matching the architecture already
locked in:**

1. **Model tests** — `test/models/*_test.rb`, `ActiveSupport::TestCase`.
   Validations/associations/scopes only, kept thin per
   [[rails-skinny-models-behavior-in-interactors]].
   ```ruby
   class LeaveRequestTest < ActiveSupport::TestCase
     test "overlapping finds requests in the same date range" do
       existing = leave_requests(:mikaela_pending)
       assert_includes LeaveRequest.overlapping(existing.start_date, existing.end_date), existing
     end
   end
   ```

2. **Controller tests** — `test/controllers/*_test.rb`,
   `ActionDispatch::IntegrationTest` (request-style: hits the real
   route, asserts on response/redirect/flash — not the old
   instance-variable-poking functional test style).
   ```ruby
   class EmployeesControllerTest < ActionDispatch::IntegrationTest
     test "creating an employee redirects to their profile" do
       sign_in hr_admins(:default)
       post employees_path, params: { employee: { full_name: "Grace Lim", start_date: "2026-09-01" } }
       assert_redirected_to employee_path(Employee.last)
     end
   end
   ```

3. **Action tests** (Interactors/Organizers, see
   [[rails-thin-controllers-organizer-interactor-pattern]]) —
   `test/interactors/**/*_test.rb`, plain `ActiveSupport::TestCase`
   against `.call`. `bin/rails test` picks up any `test/**/*_test.rb`
   automatically, no extra config needed for the custom folder.
   ```ruby
   class Employees::CreateRecordTest < ActiveSupport::TestCase
     test "fails when required fields are missing" do
       result = Employees::CreateRecord.call(employee_params: { full_name: "" })
       assert result.failure?
     end
   end
   ```

**Test data: FactoryBot + Faker.** Chosen over Rails' built-in YAML
fixtures — the one place this diverges from the "built-in default"
bias, accepted deliberately for more pleasant/varied test data given
how many employee/leave/payroll records the tests will need.

```ruby
# test/factories/employees.rb
FactoryBot.define do
  factory :employee do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    start_date { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    manager { association :employee }
  end
end
```
