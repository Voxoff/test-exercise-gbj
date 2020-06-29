Rails.application.routes.draw do
  root to: 'orders#index'
  resources :orders
  resources :deliveries, only: [:show, :index], constraints: { format: 'json' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
