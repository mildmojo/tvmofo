TvMofo::Application.routes.draw do
  resources :devices

  resources :channels do
    collection do
      get :status
    end
    member do
      get :tune
    end
  end

  root :to => 'channels#index'
end
