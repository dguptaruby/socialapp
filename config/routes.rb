Rails.application.routes.draw do
  resources :campains do 
  	member do 
      get '/update_profile_picture' => 'campains#update_profile'
  	end
    collection do 
      post '/subscription' => 'campains#subscription'
      post '/contact' => 'campains#contact'
    end
  end
  resources :users
  root to: 'users#index', via: :get
  get 'auth/facebook', as: "auth_provider"
  get 'auth/facebook/callback', to: 'campains#login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
