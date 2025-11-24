Rails.application.routes.draw do
  root "dashboard#index"
  get "dashboard", to: "dashboard#index"

  resources :subjects do
    resources :schoolworks, only: [ :new, :create ]
  end

  resources :schoolworks do
    resources :notes
    member do
      delete "remove_file/:file_id", to: "schoolworks#remove_file", as: "remove_file"
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
