---
title: rails-routes-split-into-dedicated-files
tags: [hris, rails, backend, routing]
date: 2026-08-21
---

Keep `config/routes.rb` short. Once a section grows large (e.g.
Company-tab admin routes, payroll routes, recruitment routes —
mirroring the [[navigation-me-team-company|Me/Team/Company nav
areas]]), split it into its own file rather than piling more lines
into the main file.

Rails supports drawing routes from separate files via `draw(:name)`,
which loads `config/routes/name.rb`:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root "home#index"

  resources :time_off_requests
  resources :reviews, only: [:index, :show]

  draw :company   # loads config/routes/company.rb
  draw :payroll   # loads config/routes/payroll.rb
end
```

```ruby
# config/routes/company.rb
namespace :company do
  resources :employees
  resources :payroll_runs, only: [:index, :show, :create]
end
```

Default to one file per major nav area/feature once it stops being a
handful of lines, rather than one giant `routes.rb`.
