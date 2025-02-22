Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root 'staticpages#top'

  # post,commentで共通のpathを使用するため、一番post,commentにそれぞれネストしない
  # 共通のpathを使うのは、同じviewでpost,commentのlikeを表示するため
  resources :likes, only: %i[create destroy]

  resources :posts do
    resources :comments, only: %i[create edit update destroy]
  end

  resource :profile, only: %i[show edit update]

  resources :notifications, only: %i[index]

  get 'ogp/ogp.png', to: 'ogp_images#show', as: :ogp_image

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
