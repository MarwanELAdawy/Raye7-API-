Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :groups
  resources :places
  resources :users
  resources :trips

  post 'trips/:id/join', to: 'trips#join'
  post 'trips/:id/leave', to: 'trips#leave'
end