Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }

  namespace :api do
    get :csrf, to: 'csrf#index'

    namespace :v1 do
      resources :products, only: [:create, :update, :destroy, :show, :index]
      resources :pages, only: [:create, :update, :destroy, :show, :index]
      resources :posts, only: [:create, :update, :destroy, :show, :index]
      resources :instruments, only: [:create, :update, :destroy, :show, :index]
      resources :images, only: [:create, :destroy]
      resources :firmwares, only: [:create, :destroy]

      resources :tags, only: [] do
        collection do
          match({ '/:type/' => 'tags#index', via: :get })
          match({ '/:type/:id' => 'tags#show', via: :get })
          match({ '/:type/:id' => 'tags#update', via: :put })
          match({ '/:type/:id' => 'tags#destroy', via: :delete })
        end
      end
    end
  end
end
