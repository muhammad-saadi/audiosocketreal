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
      resources :agreements, only: %i[index] do
        member do
          patch :update_status
        end
      end
      resources :artist_profiles, only:%i[] do
        collection do
          patch :update_profile
        end
      end

      resources :users, only: %i[] do
        collection do
          get :managers
          patch :accept_invitation
          get :authenticate_token
        end
      end
    end

    match '*unmatched', to: 'base#route_not_found', via: :all
  end
end
