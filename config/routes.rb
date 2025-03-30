Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "dashboard#welcome"

  devise_for :students, controllers: {
    registrations: "student/registrations"
  }
  devise_for :admins, only: %i[sessions passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    resources :courses, only: %i[index show new create edit update destroy]
    resources :enrollments, only: %i[index]
  end

  resources :contacts, only: %i[new create]
  resources :courses, only: %i[show]
end
