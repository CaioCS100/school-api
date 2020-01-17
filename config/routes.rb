Rails.application.routes.draw do
  mount_devise_token_auth_for 'Login', at: 'auth'
  resources :addresses
  resources :students
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
