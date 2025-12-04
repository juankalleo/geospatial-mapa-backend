Rails.application.routes.draw do
  namespace :api do
    # Saved features CRUD
    resources :saved_features, only: [:index, :show, :create, :update, :destroy]
    
    # Streets search
    resources :streets, only: [:index]
    
    # Layers (indigenous lands, water, protected areas)
    get 'layers', to: 'layers#index'
    
    # Route calculation A -> B
    post 'route', to: 'routes#calculate'
    
    # Health check
    get 'health', to: 'health#index'
  end

  # Health check for root
  root to: proc { [200, {}, ['Nova Mamoré Mapping API']] }
end
