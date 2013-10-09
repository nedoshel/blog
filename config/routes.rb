Blog::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  resources :posts, only: [ :index, :create ]
  root to: "posts#index"
end
