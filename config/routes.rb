Rails.application.routes.draw do
  mount_devise_token_auth_for 'Login', at: 'auth'

  resources :students do
    resource :address, only: [:show, :update, :create, :destroy]

    resource :phone, only: [:show, :update, :create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
