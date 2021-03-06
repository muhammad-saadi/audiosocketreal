Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  apipie
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :collaborator do
        resources :publishers, only: %i[index create update destroy]
        resources :artists_collaborators, only: %i[update destroy]
        resources :notes, only: %i[index create]
        resources :artists do
          collection do
            get :show_profile
            patch :update_profile
            get :collaborators
            patch :invite_collaborator
            patch :resend_collaborator_invitation
          end
        end

        resources :albums, except: %i[new edit] do
          resources :tracks, except: %i[new edit]

          member do
            post :bulk_upload_tracks
            patch :update_artwork
          end
        end

        resources :tax_forms, only: %i[] do
          collection do
            post :create_tax_form
          end
        end
      end

      resources :auditions do
        member do
          patch :assign_manager
          patch :update_status
        end

        collection do
          patch :bulk_update_status
          patch :bulk_assign_manager
          get :email_template
        end
      end

      resource :session, only: %i[create]
      resources :genres, only: %i[index]
      resources :agreements, only: %i[index]
      resources :publishers, only: %i[index create update destroy]
      resources :notes, only: %i[index create]
      resources :content, param: :key, only: [:show]
      resources :filters, only: %i[index] do
        collection do
          get :sub_filters
        end
      end

      resources :albums, except: %i[new edit] do
        resources :tracks, except: %i[new edit]

        member do
          post :bulk_upload_tracks
          patch :update_artwork
        end
      end

      resources :users_agreements, only: %i[index destroy] do
        member do
          patch :update_status
        end
      end

      resources :artists, only: %i[index] do
        collection do
          get :show_profile
          patch :update_profile
          patch :invite_collaborator
          get :collaborators
          patch :resend_collaborator_invitation
        end
      end

      resources :users, only: %i[] do
        collection do
          get :managers
          patch :accept_invitation
          get :authenticate_token
          patch :reset_password
          post :forgot_password
        end
      end

      resources :artists_collaborators, only: %i[update destroy] do
        collection do
          get :authenticate_token
        end

        member do
          patch :update_access
          patch :update_status
        end
      end

      resources :tax_forms, only: %i[] do
        collection do
          post :create_tax_form
          post :submit_tax_form
        end
      end
    end

    match '*unmatched', to: 'base#route_not_found', via: :all
  end

  root to: 'admin/dashboard#index'
end
