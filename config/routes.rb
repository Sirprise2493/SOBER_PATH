Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get 'meetings', to: 'pages#meetings', as: :meetings
end
