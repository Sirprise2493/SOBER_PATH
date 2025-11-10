Rails.application.routes.draw do
  get 'aa_venues/create'
  devise_for :users
  root to: "pages#home"
  get 'meetings', to: 'pages#meetings', as: :meetings

  resources :aa_venues, only: [:create, :destroy, :edit, :update]
end
