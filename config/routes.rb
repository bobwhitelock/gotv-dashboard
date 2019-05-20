Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'work_spaces#start'

  resources :work_spaces,
    path: 'space',
    only: [:new, :create, :show] do
    # All URLs for a work space should be nested under here, to both indicate
    # the work space each is for and for security (as the root URL for each
    # work space is secret).

    resources :turnout_observations,
      path: 'turnout',
      except: :destroy
  end
end
