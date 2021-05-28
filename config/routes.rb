Rails.application.routes.draw do
  apipie
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
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
      resources :publishers, only: %i[index create update]

      resources :albums, except: %i[new edit] do
        resources :tracks, except: %i[new edit]

        member do
          patch :update_artwork
        end
      end

      resources :users_agreements, only: %i[index] do
        member do
          patch :update_status
        end
      end

      resources :artists, only:[] do
        collection do
          get :show_profile
          patch :update_profile
          patch :invite_collaborator
          get :collaborators
        end
      end

      resources :users, only: %i[] do
        collection do
          get :managers
          patch :accept_invitation
          get :authenticate_token
        end
      end

      resources :artists_collaborators, only: %i[] do
        collection do
          get :authenticate_token
        end

        member do
          patch :update_status
        end
      end
    end

    match '*unmatched', to: 'base#route_not_found', via: :all
  end
end
