Rails.application.routes.draw do
  get "comments/index"
  get "follows/index"
  devise_for :users
  get "search/index"
  get "search" => "search#index"
  # custom routes for follow
  post "/users/:id/follow", to: "users#follow", as: "follow_user"
  post "/users/:id/unfollow", to: "users#unfollow", as: "unfollow_user"
  # custom routes for like
  post "/posts/:id/like", to: "posts#like", as: "like_posts"
  post "/posts/:id/dislike", to: "posts#dislike", as: "dislike_posts"
  # custom routes for comments
  post "/posts/:id/comment", to: "posts#createcomment", as: "create_comment"
  post "posts/:id/comments/:comment_id/delete", to: "posts#deletecomment", as: "delete_comment"
  get "home/index"
  get "home/show"
  root to: "home#index"
  post "uploads", to: "uploads#create"
  resources :users, only: [ :show, :edit, :update ] do
    # nested rote for the follows to have the user id
    get "follows", to: "follows#index"
  end
  resources :posts, only: [ :new, :create, :show, :destroy ] do
    resources :comments, only: [ :create ] do
      post "reply", on: :member  # POST /comments/:id/reply
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
