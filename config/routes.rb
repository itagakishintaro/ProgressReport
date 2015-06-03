Rails.application.routes.draw do
  # ---------- 認証関連 ----------
  root to: "reports#index"
  devise_for :users
  resources :users do
    collection do
      get 'with_progresses'
    end
  end
  resources :users

  # ---------- reports関連 ----------
  resources :reports do
    collection do
      get 'tags'
    end
  end
  resources :reports
  get 'reports/download/:id'=> 'reports#download', as: :donwload
  resources :comments do
    collection do
      get 'for_user/:user_id' => 'comments#for_user', as: :for_user
    end
  end
  resources :comments
  resources :progresses
  resources :attachments
  resources :images
  get 'images/show/:id'=> 'images#show', as: :show_image

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
