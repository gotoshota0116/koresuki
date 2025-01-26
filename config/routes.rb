Rails.application.routes.draw do
  devise_for :users
  root 'staticpages#top'
end
