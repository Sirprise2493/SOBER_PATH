Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

  get "meetings", to: "pages#meetings", as: :meetings
  get "chatroom", to: "pages#chatroom", as: :chatroom

  # Full private profile
  get  "profile",       to: "users#profile",       as: :profile
  get  "profile/edit",  to: "users#edit_profile",  as: :edit_profile
  patch "profile",      to: "users#update_profile"

  # Mini public profiles inside chat
  resources :users, only: [:show, :destroy]

  # Friendships
  resources :friendships, only: [:create, :update, :destroy]

  # Chat + AI messages
  resources :ai_chat_messages, only: [:create]

  # Journal
  get "/journal", to: "pages#journal", as: :journal
  resources :journal_contents, only: [:create, :show] do
    post :regenerate_photo, on: :member
  end

  # Milestones
  get "/milestones", to: "pages#milestones", as: :milestones

  resources :user_chat_messages, only: [:create, :show, :destroy]

  resources :user_chat_messages_responses, only: [:create, :destroy]

  resources :encouragements, only: [:create, :show]

  resources :aa_venues, only: [:create, :destroy, :edit, :update]
end
