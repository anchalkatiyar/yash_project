YashProject::Application.routes.draw do
#get request than url name than controller name and # and method name than , than as than name which is used in view	
  get "questions/index"

  get "profiles/show"

  #devise_for :users

 # devise_scope :user do
#	get 'register' , to: 'devise/registrations#new',as: :register
#	get 'login' , to: 'devise/sessions#new',as: :login
#	get 'logout' , to: 'devise/sessions#destroy',as: :logout	
#  end
  
  as :user do
	get '/register' , to: 'devise/registrations#new',as: :register
	get '/login' , to: 'devise/sessions#new',as: :login
	get '/logout' , to: 'devise/sessions#destroy',as: :logout	
  end
 
 devise_for :users,skip: [:sessions]
 
 as :user do 		
	get "/login" => 'devise/sessions#new', as: :new_user_session
	post "/login" => 'devise/sessions#create', as: :user_session
	delete "logout" => 'devise/sessions#destroy', as: :destroy_user_session
 end
 
  resources :questions, except: [:new] do
		resources :answers, only: [:create]	
  end
  
  resources :user_friendships 
  
  resources :statuses  
		get 'feed', to: 'statuses#index', as: :feed
		#root to: 'statuses#index'
		root to: 'questions#index'
		#get "user_profile", to: 'profiles#show'
		#match "profile" => "users#show", :as => 'profile'
		get "statuses/p_show/:id" => "statuses#p_show", :as => 'p_show'

		get '/your_questions', to: 'questions#your_questions'
		#get '/status_page', to: 'statuses#status_page'
		#get 'profiles/show/:id', to: 'profiles#show'
		get '/:id', to: 'profiles#show',as: 'profile'
		#get '/search', to: 'questions#search'
		# post 'search' , to: 'questions#search',as: :search
		#map.resources :search, :collection => { :index => :get, :results => :get }
		#root :to => "home#index"
		
 end
