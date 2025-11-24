Rails.application.routes.draw do
  root "home#index"
  get "home/showcase", to: "home#showcase"
  get "dashboard", to: "home#index"

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
