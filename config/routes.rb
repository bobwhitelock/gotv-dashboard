Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :work_spaces, only: :show do
    resources :turnout_observations, only: [:new, :create]
  end
  resources :turnout_observations, only: [:show]
end
