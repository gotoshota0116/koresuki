Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root 'staticpages#top'

  concern :likeable do
    resources :likes, only: %i[create destroy], shallow: true
  end

  resources :posts, concerns: :likeable do
    resources :comments, concerns: :likeable, only: %i[create edit update destroy]
  end

  resource :profile, only: %i[show edit update]

  get 'ogp/ogp.png', to: 'ogp_images#show', as: :ogp_image

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
