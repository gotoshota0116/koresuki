Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  root 'staticpages#top'

  resources :posts do
    resources :comments, only: %i[create edit update destroy]
  end

  resources :likes, only: %i[create destroy]
  resources :bookmarks, only: %i[create destroy]
  
  resource :profile, only: %i[show edit update]
  resources :notifications, only: %i[index destroy]

  get 'ogp/ogp.png', to: 'ogp_images#show', as: :ogp_image

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
