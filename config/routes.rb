Rails.application.routes.draw do
  localized do
    get '/index', to: 'app/front#index', as: :app_index
  end
  root to: 'app/front#set_locale_lang'
  scope '/:locale/:currency', defaults: { locale: 'es' }, constraints: { locale: /en|es|pt/, currency: /cop|usd/} do
    get '/', to: 'app/front#index'
    get 'vehicles', to: 'app/front#vehicles'
    get 'reservations/:vehicle_id', to: 'app/front#reservations', as: :reservations_vehicle
    get '/checkout', to: 'app/front#checkout', as: :checkout
    get '/invoice', to: 'app/front#invoice', as: :invoice
    # get '/dashboard', to: 'app/front#dashboard', as: :dashboard
    get '/dashboard/orders/transfers', to: 'app/dashboard#transfer_orders', as: :transfer_orders
    get '/dashboard/users', to: 'app/dashboard#users', as: :users_details
    post '/dashboard/users/edit', to: 'app/users#update', as: :user_update
  end

  devise_for :users#, skip: KepplerConfiguration.skip_module_devise
  post '/filter', to: 'admin/users#filter_by_role', as: :filter_by_role
  post '/session_reservation_transfer', to: 'app/reservations_transfers#session_reservation_transfer'
  post '/create_reservation_transfer', to: 'app/reservations_transfers#create_reservation_transfer'
  get  '/checkout/transaction_payment/:reservation_id/:invoice_id', to: 'app/reservations_transfers#transaction_payment', as: :checkout_elp_redirect

  namespace :admin do
    root to: 'admin#root'

    resources :roles do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      post '/upload', action: 'upload', as: :upload
      get '/download', action: 'download', as: :download
      post(
        '/sort',
        action: :sort,
        on: :collection,
      )
      get(
        '/reload',
        action: :reload,
        on: :collection,
      )
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
      # post '/show_description/:module/:action_name', action: 'show_description', as: :show_description
      # get(
      #   '/add_permissions',
      #   action: 'add_permissions',
      #   as: :add_permissions
      # )
      # post(
      #   '/create_permissions',
      #   action: 'create_permissions',
      #   as: :create_permissions
      # )
    end

    scope :roles do
      post(
        ':role_id/show_description/:module/:action_name',
        to: 'permissions#show',
        as: :role_show_description
      )
      get(
        ':role_id/add_permissions',
        to: 'permissions#add',
        as: :role_add_permissions
      )
      post(
        ':role_id/create_permissions',
        to: 'permissions#create',
        as: :role_create_permissions
      )
    end

    resources :customizes do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      post '/upload', action: 'upload', as: :upload
      post '/install_default', action: 'install_default'
    end


    resources :users do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/delete_avatar', action: :delete_avatar
      get(
        '/reload',
        action: :reload,
        on: :collection
      )
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :meta_tags do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      post '/upload', action: 'upload', as: :upload
      post(
        '/sort',
        action: :sort,
        on: :collection,
      )
      get(
        '/reload',
        action: :reload,
        on: :collection,
      )
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :scripts do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      post '/upload', action: 'upload', as: :upload
      post(
        '/sort',
        action: :sort,
        on: :collection,
      )
      get(
        '/reload',
        action: :reload,
        on: :collection,
      )
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :settings, only: [] do
      collection do
        get '/:config', to: 'settings#edit', as: ''
        put '/:config', to: 'settings#update', as: 'update'
        put '/:config/appearance_default', to: 'settings#appearance_default', as: 'appearance_default'
      end
    end
  end

  # Errors routes
  match '/403', to: 'errors#not_authorized', via: :all, as: :not_authorized
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  # Dashboard routes engine
  mount KepplerGaDashboard::Engine, at: 'admin/dashboard', as: 'dashboard'

  # Travel routes engine
  mount KepplerTravel::Engine, at: '/', as: 'travel'

  # Ckeditor routes engine
  mount Ckeditor::Engine => '/ckeditor'

end
