Rails.application.routes.draw do
  get 'ai_chat_messages/create'
  devise_for :users
  root to: "pages#home"

  # Chatroom
  get "chatroom", to: "pages#chatroom", as: :chatroom
  # AI Chat (Rest Routes for Hotwire/Turbo)
  resources :ai_chat_messages, only: [:create]
end
