Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :work_spaces, only: :show do
    resources :polling_stations, only: [:new, :create, :show]
  end
end
