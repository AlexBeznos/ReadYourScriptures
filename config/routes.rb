Rails.application.routes.draw do
  default_url_options :host => "readyourscriptures.com"
  resources :user_sessions, only: [:create, :destroy]
  get 'login' => 'user_sessions#new'

  resources :users, only: :create
  get 'account' => 'users#show'
  get 'signup' => 'users#new'

  get 'reading_plans/choose_dates' => 'schedules#step_2', as: :choose_dates
  get 'reading_plans/:id/toggle' => 'schedules#toggle', as: :toggle_schedule
  resources :reading_plans, :controller => 'schedules', as: :schedules, except: :edit

  get 'activate/:id' => 'user_activations#create', as: :activation

  namespace :admin do
    get '/' => 'users#index'
    resources :users, only: [:index, :show] do
      resources :schedules, only: :show
    end

    resources :books, except: [:show]
    resources :book_categories, except: [:show]
  end
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
