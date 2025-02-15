Rails.application.routes.draw do
  devise_for :users
  root 'staticpages#top'

  resources :posts

  get 'ogp/ogp.png', to: 'ogp_images#show', as: :ogp_image

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

#ogp/ogp.png?/test=まーごめ