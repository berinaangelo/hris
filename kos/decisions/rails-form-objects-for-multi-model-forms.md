---
title: rails-form-objects-for-multi-model-forms
tags: [hris, rails, backend, architecture]
date: 2026-08-21
---

A form that touches more than one model gets a Form Object — a PORO
(Plain Old Ruby Object) including `ActiveModel::Model` — instead of
`accepts_nested_attributes_for` sprawl.

**Canonical case: Add Employee** (see
[[../projects/hris/PLAN.md|v1 roadmap]]) touches the employee record,
org position (`manager_id`), and the onboarding checklist in one
submit.

```ruby
class AddEmployeeForm
  include ActiveModel::Model

  attr_accessor :full_name, :start_date, :manager_id

  validates :full_name, :start_date, presence: true
end
```

The Form Object validates/shapes the input; an Interactor (see
[[rails-thin-controllers-organizer-interactor-pattern]]) does the
actual persisting across models.

**How to apply:** single-model forms just use the model directly, same
as normal Rails. Reach for a Form Object once a form's fields don't
map 1:1 onto one AR model.
