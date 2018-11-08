Rails.application.routes.draw do
  localized do
    get '/index', to: 'app/front#index', as: :app_index
  end
  root to: 'app/front#set_locale_lang'
  scope '/:locale/:currency', defaults: { locale: 'es' }, constraints: { locale: /en|es|pt/, currency: /cop|usd/} do
    get '/', to: 'app/front#index', as: :index_app

    get 'vehicles', to: 'app/front#vehicles', as: :vehicles_show
    get 'tours', to: 'app/front#tours', as: :tours_show
    get 'circuits', to: 'app/front#circuits', as: :circuits_show
    get 'multidestinations/', to: 'app/front#multidestinations', as: :multidestinations_show


    get 'about', to: 'app/front#about'
    get 'contact_us', to: 'app/front#contact_us'
    get 'pqrs', to: 'app/front#pqrs', as: :pqrs

    get '/reservations/:reservationable_type/:reservationable_id', to: 'app/reservations/reservations#reservations', as: :reservations

    get '/checkout', to: 'app/reservations/reservations#checkout', as: :checkout
    get '/gracias', to: 'app/front#invoice', as: :invoice

    get '/dashboard/orders/:module', to: 'app/dashboard/dashboard#orders', as: :orders
    post '/update_order', to: 'app/dashboard/drivers/transfers#update_order', as: :update_order


    get '/dashboard/drivers/transfers', to: 'app/dashboard/dashboard#drivers', as: :drivers_transfers
    get '/dashboard/user', to: 'app/dashboard/dashboard#users', as: :users_details
    post '/dashboard/user/edit', to: 'app/dashboard/users/users#update', as: :user_update

    #new routes template dashboard
    get '/dashboard/template', to: 'app/dashboard/dashboard#template', as: :template
    get '/dashboard/template_user', to: 'app/dashboard/dashboard#template_user', as: :template_user
    get '/dashboard/template_order', to: 'app/dashboard/dashboard#template_order', as: :template_order

    get 'errors', to: 'app/front#errors', as: :errors_checkout
  end

  devise_for :users#, skip: KepplerConfiguration.skip_module_devise
  post '/filter', to: 'admin/users#index', as: :filter_by_role

  # Reservations Transfers / Vehicles
  post '/session_reservation_transfer', to: 'app/reservations/transfers/transfers#session_reservation_transfer'
  post '/create_reservation_transfer', to: 'app/reservations/transfers/transfers#create_reservation_transfer'
  # Reservations Tours
  post '/session_reservation_tour', to: 'app/reservations/tours/tours#session_reservation_tour'
  post '/create_reservation_tour', to: 'app/reservations/tours/tours#create_reservation_tour'
  # Reservations Circuits
  post '/session_reservation_circuit', to: 'app/reservations/circuits/circuits#session_reservation_circuit'
  post '/create_reservation_circuit', to: 'app/reservations/circuits/circuits#create_reservation_circuit'
  # Reservations Multidestinations
  post '/session_reservation_multidestination', to: 'app/reservations/multidestinations/multidestinations#session_reservation_multidestination'
  post '/create_reservation_multidestination', to: 'app/reservations/multidestinations/multidestinations#create_reservation_multidestination'


  get  '/checkout/transaction_payment/:reservation_id/:invoice_id', to: 'app/reservations/reservations#transaction_payment', as: :checkout_elp_redirect

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
      get '/assign_partner', action: :assign_partner
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

  # Contactus routes engine
  mount KepplerContactus::Engine, at: '/', as: 'contactus'

  # Ckeditor routes engine
  mount Ckeditor::Engine => '/ckeditor'

end
