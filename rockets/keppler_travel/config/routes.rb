KepplerTravel::Engine.routes.draw do
  # Resources Reservations

  namespace :admin do
    scope :travel, as: :travel do

      resources :agencies do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

        resources :agents do
          get '(page/:page)', action: :index, on: :collection, as: ''
          get '/clone', action: 'clone'
          post '/sort', action: :sort, on: :collection
          post '/upload', action: 'upload', as: 'upload'
          get '/download', action: 'download', as: 'download'
          post '/update_user', action: :update_user
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

      end


      namespace :destinations do
        post 'filter_by_destination', action: :index, as: :filter_destination
      end

      namespace :drivers do
        post '/update_user', action: :update_user
        post 'filter_by_destination', action: :index, as: :filter_destination
      end

      namespace :agencies do
        post '/update_user', action: :update_user
      end

      namespace :lodgments do
        post 'filter_by_destination', action: :index, as: :filter_destination
      end

      namespace :multidestinations do
        post 'filter_by_destination', action: :index, as: :filter_destination
      end

      namespace :vehicles do
        post 'filter_by_destination', action: :index, as: :filter_destination
      end

      namespace :tours do
        post 'filter_by_destination', action: :index, as: :filter_destination
      end

      namespace :reservations do
        post '/assignment', action: :assignment, as: :assign_driver
        get '/unassign', action: :unassign, as: :unassign_driver
      end

      resources :drivers do
        get '/description_tables', action: :description_tables, as: :description_tables
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

      resources :circuits do
        get '/rooms_tables', action: :rooms_tables, as: :rooms_tables
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

      resources :rankings do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

      resources :lodgments do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

      resources :multidestinations do
        get '/rooms_tables', action: :rooms_tables, as: :rooms_tables
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

      resources :tours do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

      resources :reservations do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

      resources :destinations do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

      resources :vehicles do
        get '/prices_tables', action: :prices_tables, as: :prices_tables
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

    end
  end
end
