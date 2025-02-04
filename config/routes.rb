Rails.application.routes.draw do
  devise_for :users
  root 'staticpages#top'

  resources :posts, only: %i[index]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
