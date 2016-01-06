Rails.application.routes.draw do
  root 'welcome#index'

  resources :establishments, except: [:show, :index]
  resources :companies, except: [:show, :index]
  resources :admins, except: [:show, :index]

  get 'companies/index'
  get 'companies/sign_in'
  get 'companies/sign_up'
  post 'companies/register'
  post 'companies/log_in'
  get 'companies/log_out'
  get 'companies/containers'
  get 'companies/request_container'
  get 'companies/request_container_choose_establishment'
  get 'companies/request_container_last_step'
  get 'companies/update_state_container'
  get 'companies/configuration'
  get 'companies/drop_out'
  post 'companies/edit_data'
  post 'companies/edit_password'
  post 'companies/modify_data'

  get 'establishments/index'
  get 'establishments/sign_in'
  get 'establishments/sign_up'
  post 'establishments/register'
  post 'establishments/log_in'
  get 'establishments/log_out'
  get 'establishments/drop_out'
  get 'establishments/containers'
  get 'establishments/accept_container_request'
  get 'establishments/configuration'
  post 'establishments/edit_data'
  post 'establishments/edit_password'
  get 'establishments/update_state_container'
  post 'establishments/delete_container'

  get 'admins/index'
  get 'admins/sign_in'
  get 'admins/sign_up'
  post 'admins/log_in'
  get 'admins/log_out'
  get 'admins/new_company'
  post 'admins/accept_company'
  get 'admins/new_establishment'
  post 'admins/accept_establishment'
  get 'admins/change_request'
  post 'admins/accept_change_request'

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
