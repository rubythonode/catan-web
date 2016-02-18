Rails.application.routes.draw do
  sso_devise
  root 'pages#home'

  resources :issues

  resources :posts, only: [] do
    resources :comments, shallow: true
  end

  resources :articles
  resources :opinions do
    resources :votes
  end

  get '/i/:slug', to: "issues#slug", as: 'slug_issue'
end
