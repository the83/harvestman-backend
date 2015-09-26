Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :products
      resources :pages
      resources :posts
      resources :instruments

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
