Rails.application.routes.draw do
  sso_devise
  root 'issues#slug', slug: '기본소득'

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

  get '/i/:slug', to: "issues#slug", as: 'slug_issue'
  get '/tags/:name', to: "tags#show", as: 'show_tag'
end
