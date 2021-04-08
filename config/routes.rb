Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :auditions
    end

    match '*unmatched', to: 'base#route_not_found', via: :all
  end
end
