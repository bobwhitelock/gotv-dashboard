Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'work_spaces#start'

  resources :work_spaces, path: 'space', only: [:new, :create, :show] do
    # All URLs for a workspace should be nested under here, to both indicate
    # the workspace each is for and for security (as the root URL for each
    # workspace is secret).

    resource :configuration, only: [:show, :update]

    resources :turnout_observations, path: 'turnout', except: :destroy do
      collection do
        get :start
      end
    end

    resources :committee_rooms, path: 'committee-room', except: :index do
      post :canvassers
      post :cars
    end
  end

  resources :users, only: :update
end
