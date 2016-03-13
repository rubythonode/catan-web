Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  #sso_devise

  root 'pages#home'

  resources :users, except: :show

  resources :issues do
    member do
      get :users
      get :campaign
    end
    collection do
      get :exist
    end
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

  resources :articles
  resources :opinions do
    get 'social_card', on: :member
  end
  resources :questions do
    resources :answers, shallow: true
  end
  resources :discussions do
    resources :proposals, shallow: true
  end
  resources :relateds

  get '/welcome', to: "pages#welcome", as: 'welcome'
  get '/dashboard', to: "pages#dashboard", as: 'dashboard'
  get '/about', to: "pages#about", as: 'about'
  get '/i/:slug', to: "issues#slug", as: 'slug_issue'
  get '/i/:slug/campaign', to: "issues#slug_campaign", as: 'slug_issue_campaign'
  get '/u/:nickname', to: "users#gallery", as: 'nickname_user'
  get '/tags/:name', to: "tags#show", as: 'show_tag'
  authenticate :user, lambda { |u| u.admin? } do
    get '/test/summary', to: "users#summary_test"
  end
  get "transfers/start", as: "start_transfers"
  post "transfers/confirm", as: "confirm_transfers"
  get "transfers/final", as: "final_transfers"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/devel/emails"
  end
end
