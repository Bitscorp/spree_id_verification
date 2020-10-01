Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    resources :users, only: [] do
      member do
        get :verification
        post :verify
        post :reject
      end
    end
  end
end
