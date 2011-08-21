YuxGallery::Application.routes.draw do

  devise_for :users, :controllers => { :sessions => "users/sessions" }

  resources :users, :except => [ :show, :new, :create ], :shallow => true do
    member do
      get "/folders(.:format)" => "users#folders", :as => "folders"
    end
    resources :albums, :except => [ :show ], :shallow => true do
      resources :scans
      resources :photos
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "users#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
#== Route Map
# Generated on 19 Feb 2011 15:51
#
#       new_user_session GET    /users/sign_in(.:format)                                   {:controller=>"devise/sessions", :action=>"new"}
#           user_session POST   /users/sign_in(.:format)                                   {:controller=>"devise/sessions", :action=>"create"}
#   destroy_user_session GET    /users/sign_out(.:format)                                  {:controller=>"devise/sessions", :action=>"destroy"}
#          user_password POST   /users/password(.:format)                                  {:controller=>"devise/passwords", :action=>"create"}
#      new_user_password GET    /users/password/new(.:format)                              {:controller=>"devise/passwords", :action=>"new"}
#     edit_user_password GET    /users/password/edit(.:format)                             {:controller=>"devise/passwords", :action=>"edit"}
#                        PUT    /users/password(.:format)                                  {:controller=>"devise/passwords", :action=>"update"}
#      user_registration POST   /users(.:format)                                           {:controller=>"devise/registrations", :action=>"create"}
#  new_user_registration GET    /users/sign_up(.:format)                                   {:controller=>"devise/registrations", :action=>"new"}
# edit_user_registration GET    /users/edit(.:format)                                      {:controller=>"devise/registrations", :action=>"edit"}
#                        PUT    /users(.:format)                                           {:controller=>"devise/registrations", :action=>"update"}
#                        DELETE /users(.:format)                                           {:controller=>"devise/registrations", :action=>"destroy"}
#        user_album_scan POST   /users/:user_id/albums/:album_id/scan(.:format)            {:controller=>"scans", :action=>"create"}
#    new_user_album_scan GET    /users/:user_id/albums/:album_id/scan/new(.:format)        {:controller=>"scans", :action=>"new"}
#   edit_user_album_scan GET    /users/:user_id/albums/:album_id/scan/edit(.:format)       {:controller=>"scans", :action=>"edit"}
#                        GET    /users/:user_id/albums/:album_id/scan(.:format)            {:controller=>"scans", :action=>"show"}
#                        PUT    /users/:user_id/albums/:album_id/scan(.:format)            {:controller=>"scans", :action=>"update"}
#                        DELETE /users/:user_id/albums/:album_id/scan(.:format)            {:controller=>"scans", :action=>"destroy"}
#      user_album_photos GET    /users/:user_id/albums/:album_id/photos(.:format)          {:controller=>"photos", :action=>"index"}
#                        POST   /users/:user_id/albums/:album_id/photos(.:format)          {:controller=>"photos", :action=>"create"}
#   new_user_album_photo GET    /users/:user_id/albums/:album_id/photos/new(.:format)      {:controller=>"photos", :action=>"new"}
#  edit_user_album_photo GET    /users/:user_id/albums/:album_id/photos/:id/edit(.:format) {:controller=>"photos", :action=>"edit"}
#       user_album_photo GET    /users/:user_id/albums/:album_id/photos/:id(.:format)      {:controller=>"photos", :action=>"show"}
#                        PUT    /users/:user_id/albums/:album_id/photos/:id(.:format)      {:controller=>"photos", :action=>"update"}
#                        DELETE /users/:user_id/albums/:album_id/photos/:id(.:format)      {:controller=>"photos", :action=>"destroy"}
#            user_albums GET    /users/:user_id/albums(.:format)                           {:controller=>"albums", :action=>"index"}
#                        POST   /users/:user_id/albums(.:format)                           {:controller=>"albums", :action=>"create"}
#         new_user_album GET    /users/:user_id/albums/new(.:format)                       {:controller=>"albums", :action=>"new"}
#        edit_user_album GET    /users/:user_id/albums/:id/edit(.:format)                  {:controller=>"albums", :action=>"edit"}
#             user_album PUT    /users/:user_id/albums/:id(.:format)                       {:controller=>"albums", :action=>"update"}
#                        DELETE /users/:user_id/albums/:id(.:format)                       {:controller=>"albums", :action=>"destroy"}
#                  users GET    /users(.:format)                                           {:controller=>"users", :action=>"index"}
#              edit_user GET    /users/:id/edit(.:format)                                  {:controller=>"users", :action=>"edit"}
#                   user PUT    /users/:id(.:format)                                       {:controller=>"users", :action=>"update"}
#                        DELETE /users/:id(.:format)                                       {:controller=>"users", :action=>"destroy"}
#                   root        /(.:format)                                                {:controller=>"users", :action=>"index"}
