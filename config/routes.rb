ActionController::Routing::Routes.draw do |map|
#  map.resources :activities

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.home '/', :controller => 'topics', :action => 'index'
  map.settings '/settings', :controller => 'users', :action => 'settings'
  map.search '/search', :controller => 'topics', :action => 'search'
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  map.explore '/explore', :controller => 'topics', :action => 'popular'
  map.image '/settings/image', :controller => 'users', :action => 'image'
  map.password '/settings/password', :controller => 'users', :action => 'password'
  map.my_topics '/settings/topics', :controller => 'users', :action => 'topics'
  map.myhome '/myhome', :controller => 'users', :action => 'myhome'
  map.my_posts '/myhome/my_posts', :controller => 'users', :action => 'myposts'
  map.my_replies '/myhome/my_replies', :controller => 'users', :action => 'myreplies'
  
  map.resources :users do |user|
    user.resources :activities
  end

  map.resource :session

  map.resource :image

#  map.resources :replies

#  map.resources :posts

  map.resources :topics do |topic|
    topic.resources :posts do |post|
      post.resources :replies
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "topics"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
