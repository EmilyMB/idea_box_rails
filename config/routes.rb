Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'
  get '/not_found', to: redirect('/404')


  root :to => 'sessions#new'
  resources :users
  resources :ideas, only: [:create, :edit, :new, :destroy, :update]
  scope module: 'admin' do
    resources :categories,  only: [:create, :index, :new, :destroy]
    post '/new', to: 'category#new'
    resources :images, only: [:index, :create, :edit, :new, :destroy, :update]

  end

end
