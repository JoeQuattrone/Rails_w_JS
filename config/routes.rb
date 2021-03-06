Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#index'

  get '/privacypolicy' => 'users#privacy_policy'
  get '/auth/facebook/callback' => 'sessions#create'
  get '/users/signin', to: 'users#signin', as: 'signin'
  post '/login', to: 'users#login'
  get '/logout', to: 'users#logout'

  post '/hotels', to: 'hotels#search'
  post '/hotels/:id/visits/new', to: 'visits#check_availability'

  resources :users
  resources :hotels
  resources :hotels, only: [:index] do
    resources :visits, only: [:new]
    get '/visits/last', to: 'visits#last_visit'
    post '/visits/last', to: 'visits#create'
  end

  resources :users, only: [:show] do
    resources :visits, except: [:new]
    get '/visits/:id/next', to: 'visits#next_visit'
  end

  post "/search", to: 'searches#index'
  get '/allhotels', to: 'searches#all_hotels'

end
