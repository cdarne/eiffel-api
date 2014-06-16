Rails.application.routes.draw do
  resources :surveys, except: [:new, :edit, :update]
end
