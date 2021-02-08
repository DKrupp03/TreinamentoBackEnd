Rails.application.routes.draw do
  
  root "posts#index"

  resources :users
  resources :posts, except: [:new, :edit] do
    resources :comments, except: [:new, :edit]
  end

  resources :tags

  post "/posts/:id/tag", controller: :posts, action: :link_tag
  delete "/posts/:id/tag", controller: :posts, action: :unlink_tag

  post "/login", to: "users#login"


end
