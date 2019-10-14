Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
  end

  root to: 'accounts#index'

  resources :accounts, only: [:index] do
    get :transactions, on: :member
  end

  resources :money_transfers, only: [:new, :create]
end
