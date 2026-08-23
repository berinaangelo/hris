Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#show"

  resource :session, only: [:new, :create, :destroy]

  resources :leave_requests, only: [:index, :new, :create]

  namespace :team do
    resources :approvals, only: [:index] do
      member do
        patch :approve
        patch :reject
      end
    end
  end

  # Split into config/routes/*.rb (via `draw`) once a section grows —
  # see kos/decisions/rails-routes-split-into-dedicated-files.md. Not
  # worth it yet at this line count.
end
