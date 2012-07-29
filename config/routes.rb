TvMofo::Application.routes.draw do
  resources :devices

  resources :channels

  root :to => 'channels#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  match 'railsthemes/landing' => 'railsthemes#landing'
  match 'railsthemes/inner' => 'railsthemes#inner'
  match 'railsthemes/jquery_ui' => 'railsthemes#jquery_ui'
end
