Rails.application.routes.draw do
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
          patch :bulk_assign_managers
        end
      end
      resource :session, only: %i[create]
      resources :genres, only: %i[index]

      resources :users, only: %i[] do
        collection do
          get :managers
        end
      end
    end

    match '*unmatched', to: 'base#route_not_found', via: :all
  end
end
