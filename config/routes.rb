Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  #sso_devise

  root 'issues#slug', slug: 'all'

  resources :users

  resources :issues do
    get :users, on: :member
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
  resources :opinions
  resources :questions do
    resources :answers, shallow: true
  end
  resources :discussions do
    resources :proposals, shallow: true
  end
  resources :relateds

  get '/welcome', to: "pages#welcome", as: 'welcome'
  get '/dashboard', to: "pages#dashboard", as: 'dashboard'
  get '/i/:slug', to: "issues#slug", as: 'slug_issue'
  get '/u/:nickname', to: "users#home", as: 'nickname_user'
  get '/tags/:name', to: "tags#show", as: 'show_tag'
  authenticate :user, lambda { |u| u.admin? } do
    get '/test/summary', to: "users#summary_test"
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/devel/emails"
  end
end
