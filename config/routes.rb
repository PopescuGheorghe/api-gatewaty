Rails.application.routes.draw do
  namespace :api do
    post 'session/login' => 'sessions#login'
    delete 'session/logout/:id' => 'sessions#logout'
    post 'send_email' => 'mails#send_email'
    get 'users/me' => 'users#me'
    resources :users, only: [:show, :index, :create, :update, :destroy]
  end
end
