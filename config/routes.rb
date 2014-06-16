Rails.application.routes.draw do
  resources :surveys, except: [:new, :edit, :update] do
    post :answer, on: :member
  end
end
