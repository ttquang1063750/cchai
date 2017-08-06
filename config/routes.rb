require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at: "/sidekiq"
  mount Crono::Web, at: '/crono'
  mount_devise_token_auth_for 'Admin', at: 'admin/auth', skip: [:omniauth_callbacks]
  as :admin do
    namespace :api do
      namespace :v1 do
        namespace :admin do
          resources :users do
            collection do
              get :search
            end
          end
          resources :projects do
            resources :batch_processes, only: [:index, :create, :update, :show, :destroy]
            collection do
              get :search
            end
            member do
              get 'users', to: 'projects#users'
              post 'clone', to: 'projects#clone'
            end
            resources :roles, only: [:create, :destroy, :index, :show] do
              post :create_multiple, on: :collection
            end
            resources :sites, only: [:create, :destroy, :index, :show]
            resources :pages, only: [:index, :create, :update, :show, :destroy] do
              resources :operations
              resources :local_variables do
                post :create_multiple, on: :collection

              end
            end
            resources :role_types, only: [:index, :create, :update, :show, :destroy] do
              member do
                get :users, to: 'role_types#users'
              end
              collection do
                post 'creates', to: 'role_types#creates'
              end
            end
            resources :site_infos, only: [:index, :create, :update, :show, :destroy] do
              member do
                get :users, to: 'site_infos#users'
              end
            end
            resources :tables do
              resources :columns
            end

            resources :session_variables do
              post :create_multiple, on: :collection
            end
            resources :pictures
            resources :db_connects
          end

          resources :db_connects do
            collection do
              get 'all', to: 'db_connects#all'
            end
          end  
          
          resources :clients
          resources :item_masters do
            collection do
              get :search
            end
            member do
              post 'clone', to: 'item_masters#clone'
            end
          end
          resources :pictures
        end
      end
    end
  end

  mount_devise_token_auth_for 'User', at: 'user/auth', skip: [:omniauth_callbacks]
  as :user do
    namespace :api do
      namespace :v1 do
        namespace :user do
          resources :projects, only: [:show] do
            resources :pages, only:[:show] do
              member do
                post :show_operation
                post :create_csv_export
                post :submit
                post :create_or_update
                delete :delete
                get :display_csv_export
                post :send_email
              end
            end
            get :get_query, controller: :datasources, action: :get_query
          end
        end
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
