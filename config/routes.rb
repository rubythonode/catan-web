Rails.application.routes.draw do
  sso_devise
  root 'pages#home'
end
