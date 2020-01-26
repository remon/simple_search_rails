Rails.application.routes.draw do
  # get 'pages/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :products
  end

  root to: "pages#index"
end
