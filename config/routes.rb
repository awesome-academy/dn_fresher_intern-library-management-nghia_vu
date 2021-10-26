Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "static_pages/home"
    devise_for :users
    as :user do
      get "/login", to: "devise/sessions#new"
      post "/login", to: "devise/sessions#create"
      delete "/logout", to: "devise/sessions#destroy"
      get "/signup", to: "devise/registrations#new"
      post "/signup", to: "devise/registrations#create"
    end
    resources :books, only: :show
    resources :carts, only: %i(index create destroy) do
      get :reset, on: :collection
    end
    resources :shops, only: %i(show index)
    resources :users, only: %i(show) do
      resources :shops, only: %i(new create)
      namespace :shop do
        resources :orders, only: %i(index show) do
          member do 
            put :approve
            put :disclaim
          end
        end
        resource :shops, only: :show
        resources :books do
          collection {post :import}
        end
      end
      resources :orders, only: %i(new create index show) do
        put :cancel, on: :member
      end
    end
  end
end
