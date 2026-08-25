Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#show"

  resource :session, only: [ :new, :create, :destroy ]
  resources :password_resets, param: :token, only: [ :new, :create, :edit, :update ]

  # Public, unauthenticated — see app/controllers/careers_controller.rb.
  get "apply/:slug", to: "careers#show", as: :careers
  post "apply/:slug", to: "careers#create"

  resources :leave_requests, only: [ :index, :new, :create ]
  resources :attendance_correction_requests, only: [ :index, :new, :create ]
  resources :review_cycles, only: [ :index ]

  namespace :team do
    resource :calendar, only: :show, controller: "calendar"

    resources :approvals, only: [ :index ] do
      member do
        patch :approve
        patch :reject
      end
    end

    # :index dropped 2026-08-24 — folded into team_attendance_records_path
    # as part of the Team Attendance merge, see kos/decisions/ux-pages/time-attendance.html.
    # member routes aren't gated by `only:`, so approve/reject stay.
    resources :attendance_correction_requests, only: [] do
      member do
        patch :approve
        patch :reject
      end
    end

    resources :attendance_records, only: [ :index, :update ]
    resources :shift_templates, only: [ :create, :update, :destroy ]
    resources :attendance_edit_approvals, only: [ :index ] do
      member do
        patch :approve
        patch :reject
      end
    end
    resource :attendance_settings, only: :update

    resources :review_cycles, only: [ :index, :create ] do
      member do
        patch :save_draft
        patch :publish
        patch :attach_kpis
      end
    end
  end

  resources :employees, path: "people", only: [ :index, :new, :create, :show, :update ] do
    member do
      patch :schedule_offboarding
      patch :mark_offboarded
    end
    resources :checklist_items, only: [], controller: "employees/checklist_items" do
      patch :complete, on: :member
    end
    resources :documents, only: [ :create ], controller: "employees/documents"
    resources :benefit_enrollments, only: [ :create, :update, :destroy ], controller: "employees/benefit_enrollments"
    resources :loans, only: [ :create, :update, :destroy ], controller: "employees/loans"
  end

  resource :attendance, only: [], controller: "attendance" do
    post :clock_in
    patch :clock_out
  end

  resources :roles_access, only: [ :index, :update ]
  resources :rate_tables, only: [ :index, :edit, :update ]
  resource :payroll_settings, only: [ :show, :update ]
  resources :payroll_runs, only: [ :index, :new, :create, :show ] do
    member do
      patch :finalize
    end
  end
  resources :payslips, only: [ :index, :show ] do
    member do
      patch :void_and_reissue
      patch :finalize
    end
    resources :line_items, only: [ :create, :update, :destroy ], controller: "payslips/line_items"
  end
  resources :certifications, only: [ :index, :new, :create, :edit, :update, :destroy ]
  resources :company_review_cycles, only: [ :index, :new, :create, :show ]
  get "reports", to: "reports#index"
  get "reports/:id", to: "reports#show", as: :report

  resources :job_openings, only: [ :index, :new, :create, :show, :edit, :update ]
  resources :job_candidates, only: [ :update ] do
    member do
      get :new_hire
      post :hire
    end
  end

  resource :my_profile, only: [ :show, :edit, :update ], controller: "my_profile"
  resource :account_settings, only: [ :show, :update ], controller: "account_settings"
  resource :password, only: [ :edit, :update ], controller: "passwords"
  get "org_chart", to: "org_chart#show"

  # Split into config/routes/*.rb (via `draw`) once a section grows —
  # see kos/decisions/rails-routes-split-into-dedicated-files.md. Not
  # worth it yet at this line count.
end
