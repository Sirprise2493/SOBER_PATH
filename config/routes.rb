Rails.application.routes.draw do
  get 'aa_venues/create'
  devise_for :users
  root to: "pages#home"
  get 'meetings', to: 'pages#meetings', as: :meetings
  get 'about', to: 'pages#about', as: :about

  resources :aa_venues, only: [:create, :destroy, :edit, :update]
  get 'ai_chat_messages/create'

  # Chatroom
  get "chatroom", to: "pages#chatroom", as: :chatroom
  # AI Chat (Rest Routes for Hotwire/Turbo)
  resources :ai_chat_messages, only: [:create]
end
