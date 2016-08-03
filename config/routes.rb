Rails.application.routes.draw do
  root 'base#dashboard'

  match '/changes/(:from_date)/(:to_date)' => 'base#changes', :via => 'get'
  match '/changes_by_service/(:from_date)/(:to_date)' => 'base#changes_by_service', :via => 'get'
  match '/changes_for_services/(:from_date)/(:to_date)/(:services)' => 'base#changes_for_services', :via => 'get'
  match '/changes_by_service_and_region/(:from_date)/(:to_date)/(:services)' => 'base#changes_by_service_and_region', :via => 'get'
  match '/changes_for_services_and_regions/(:from_date)/(:to_date)/(:services)/(:regions)' => 'base#changes_for_services_and_regions', :via => 'get'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
