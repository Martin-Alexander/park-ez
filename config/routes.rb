Rails.application.routes.draw do
  root to: "pages#landing"

  resources :places, only: [:index]
end
