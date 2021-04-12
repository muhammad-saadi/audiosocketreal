Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :auditions do
        patch :assign_manager, on: :member
      end
      resource :session, only: %i[create]
      resources :genres, only: %i[index]

      get 'users/managers', to: 'users#managers'
    end

    match '*unmatched', to: 'base#route_not_found', via: :all
  end
end
