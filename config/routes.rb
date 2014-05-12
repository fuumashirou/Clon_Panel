Panel::Application.routes.draw do
  
  resources :songs
  require 'sidekiq/web'

  devise_for :accounts,  skip: [ :registrations ]
  devise_for :admins,    skip: [ :sessions, :registrations ]
  devise_for :managers,  skip: :sessions, controllers: { registrations: "accounts/registrations", confirmations: "accounts/confirmations" }
  devise_for :employees, skip: :sessions, controllers: { registrations: "accounts/registrations", confirmations: "accounts/confirmations" }

  resources :stores do
    get "menu_song/new"
    get "menu_song/create"
    get  "menu/new"
    post "menu/create"
    resource  :happy_hour
    resource  :schedule
    resource  :karaoke
    resources :promotions
    resources :employees
    resources :payment_methods
    resources :billings
    resources :contacts
    resources :waiters
    resources :songs
    resources :tables do
      collection do
        get   "display"
        patch "update_all"
      end
      member do
        patch "update_token"
      end
    end
    resources :selections do
      collection do
        get "multi_stock"
      end
      resources :selection_items do
        member do
          patch "stock"
        end
      end
    end
    resources :items do
      member do
        patch "stock"
      end
      collection do
        get "multi_stock"
      end
    end
    resources :orders do
      member do
        get "print_order"
       get "print_bill"
      end
      collection do
        get "history"
      end
    end
    resources :checkin_billings do
      member do
        get "discount"
        post "apply_discount"
      end
    end
    resources :categories
    resources :checkins do
      member do
        post "change"
        delete "leave"
      end
      collection do
        delete "leave_all"
      end
    end
    member do
      get "confirm"
      get "manage"
      patch "verify"
      patch "change_token"
    end
  end

  resources :checkins do
    resources :accounts
    resources :billings
    resources :orders
  end
  resources :currencies
  resources :users
  resources :admins do
    collection do
      get "sidekiq"
    end
  end
  root "pages#index"

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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  namespace :admins do
    get 'logs/application' => 'logs#application'
    get 'logs/production'  => 'logs#production'
    get 'logs/sidekiq'     => 'logs#sidekiq'
  end

  # authenticate :accounts, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  # end

  post '/payment/notification/:method' => 'payment_methods#notification'
end
