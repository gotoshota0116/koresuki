Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root 'staticpages#top'

  resources :posts do
    resources :likes, only: [:create, :destroy]
  end

  resource :profile, only: [:show, :edit, :update]

  get 'ogp/ogp.png', to: 'ogp_images#show', as: :ogp_image

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
