class UserFriendshipsController < ApplicationController
before_filter :authenticate_user!#, only: [:new]

	def index
		@user_friendships = current_user.user_friendships.all
		#redirect_to user_friendships_path
	end
=begin
	def accept
		@user_friendships = current_user.user_friendships.find(params[:id])
		
		if @user_friendship.accept!
			flash[:success] = "You are now friends with #{@user_friendship.friend.first_name}"
		else
			flash[:error] = "That friend could not be accepted!"
		end
		redirect_to user_friendships_path
		
#		@user_friendship = current_user.user_friendships.find(params[:id])
#		if @user_friendship.accept!
#		  flash[:success] = "You are now friends with #{@user_friendship.friend.first_name}"
#		else
#		  flash[:error] = "That friendship could not be accepted."
#		end
#		redirect_to user_friendships_path
	end
=end
	def accept
    @user_friendship = current_user.user_friendships.find(params[:id])
    if @user_friendship.accept!
      flash[:success] = "You are now friends with #{@user_friendship.friend.first_name}"
    else
      flash[:error] = "That friendship could not be accepted."
    end
    redirect_to user_friendships_path
  end
	
	def new
		#unless params[:friend_id]
		#	flash[:error] = "Friend Required"
		#end
		# the above code is same as the below if else statement
		if params[:friend_id]
			#@friend = User.find(params[:friend_id])
			@friend = User.where(profile_name: params[:friend_id]).first
			raise ActiveRecord::RecordNotFound if @friend.nil?
			#logger.info "trying to find a friend"
			#logger.info @friend
			
			@user_friendship = current_user.user_friendships.new(friend: @friend)
		else
			flash[:error] = "Friend Required"
		end
		
		rescue ActiveRecord::RecordNotFound
			render file: 'public/404' , status: :not_found
	end
	
	
	
	def create
		if params[:user_friendship] && params[:user_friendship].has_key?(:friend_id)
			@friend = User.where(profile_name: params[:user_friendship][:friend_id]).first
			#@user_friendship = current_user.user_friendships.new(friend: @friend)
			@user_friendship = UserFriendship.request(current_user, @friend)
			#@user_friendship.save
			if @user_friendship.new_record?
				flash[:error] = "Problem in creating friend !"
				 redirect_to profile_path(@friend)
			else	
				#flash[:success] = "you are now friends with #{@friend.full_name}"
				flash[:success] = "Friend Request Sent"	
			end	
			redirect_to profile_path(@friend)
		else
			flash[:error] = "Friend Required"
			redirect_to root_path
		end	
	end
	
	
	
	def edit
		@user_friendship = current_user.user_friendships.find(params[:id])
		@friend = @user_friendship.friend
	end
	
	
	def destroy
		@user_friendship = current_user.user_friendships.find(params[:id])
		if @user_friendship.destroy
			flash[:success] = "Friendship destroyed"
		end	
		 redirect_to user_friendships_path
	end
end
