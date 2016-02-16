Rails.application.routes.draw do
  sso_devise
  root 'pages#home'
  resources :articles
  resources :issues

  get '/i/:slug', to: "issues#slug", as: 'slug_issue'
end
