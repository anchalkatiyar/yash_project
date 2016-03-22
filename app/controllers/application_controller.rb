class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method [ :logged_in?]
  
 
   def logged_in?
	!current_user.nil?
  end
  def auth
	redirect_to login_url,alert: "You must login !" unless logged_in?
  end
end
