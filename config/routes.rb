Rails.application.routes.draw do
  namespace :recruiters do
    resources :submissions, only: %i[show create]
    resources :jobs, only: %i[index show create update]
  end

  namespace :public do
    resources :jobs, only: %i[index show]
  end

  post 'login',    to: 'authentication#login'
  post 'register', to: 'authentication#register'

end
