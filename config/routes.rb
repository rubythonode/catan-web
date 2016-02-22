Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  #sso_devise

  if Rails.env.staging? or Rails.env.production?
    root 'pages#basic_income'
  else
    root 'issues#slug', slug: 'all'
  end

  resources :issues do
    resources :watches do
      delete :cancel, on: :collection
    end
  end

  resources :posts, only: [] do
    shallow do
      resources :comments
      resources :votes
      resources :likes do
        delete :cancel, on: :collection
      end
    end
  end
  get 'likes', to: "likes#by_me", as: 'likes_by_me'

  resources :articles
  resources :opinions
  resources :questions do
    resources :answers, shallow: true
  end

  get '/welcome', to: "pages#welcome", as: 'welcome'
  get '/dashboard', to: "pages#dashboard", as: 'dashboard'
  get '/i/:slug', to: "issues#slug", as: 'slug_issue'
  get '/tags/:name', to: "tags#show", as: 'show_tag'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/devel/emails"
  end
end
