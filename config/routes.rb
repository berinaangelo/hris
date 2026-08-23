Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#show"

  resource :session, only: [ :new, :create, :destroy ]

  resources :leave_requests, only: [ :index, :new, :create ]
  resources :attendance_correction_requests, only: [ :index, :new, :create ]

  namespace :team do
    resources :approvals, only: [ :index ] do
      member do
        patch :approve
        patch :reject
      end
    end

    resources :attendance_correction_requests, only: [ :index ] do
      member do
        patch :approve
        patch :reject
      end
    end

    resources :attendance_records, only: [ :index, :edit, :update ]
    resources :attendance_edit_approvals, only: [ :index ] do
      member do
        patch :approve
        patch :reject
      end
    end
    resource :attendance_settings, only: :update
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
  end

  resource :attendance, only: [], controller: "attendance" do
    post :clock_in
    patch :clock_out
  end

  resources :roles_access, only: [ :index, :edit, :update ]
  resources :certifications, only: [ :index, :new, :create, :edit, :update, :destroy ]

  resource :my_profile, only: [ :show, :edit, :update ], controller: "my_profile"
  resource :account_settings, only: [ :show, :update ], controller: "account_settings"
  resource :password, only: [ :edit, :update ], controller: "passwords"
  get "org_chart", to: "org_chart#show"

  # Split into config/routes/*.rb (via `draw`) once a section grows —
  # see kos/decisions/rails-routes-split-into-dedicated-files.md. Not
  # worth it yet at this line count.
end
