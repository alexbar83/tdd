Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'confirmations' }
  root to: 'questions#index'

  concern :votable do
    member { post :vote }
    member { post :revote }
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, concerns: [:votable] do
      patch :best, on: :member
      resources :comments, defaults: { commentable: 'answer' }
    end
    resources :comments, defaults: { commentable: 'question' }
  end
  
  namespace :api do
  namespace :v1 do
    resource :profiles, only: [] do
      get :me, on: :collection
    end

    resources :questions, only: [:index]
  end
end

  resources :attachments, only: :destroy
  resources :awards, only: :index
end
