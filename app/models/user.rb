class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :profile_name , :address, :city, :mobile_number, :avatar,:picture
  
  has_many :albums
  has_many :pictures
  has_many :statuses
  has_many :questions
  has_many :answers
  has_many :user_friendships
  has_many :friends,through: :user_friendships, 
							  conditions: {user_friendships:{state: 'accepted'}}
  
  
  has_many :pending_user_friendships,class_name: 'UserFriendship',
									foreign_key: :user_id,									
									conditions: {state: 'pending'}
  
  has_many :pending_friends, through: :pending_user_friendships,source: :friend
  
  has_many :requested_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'requested' }
  has_many :requested_friends, through: :requested_user_friendships, source: :friend
  
  has_many :blocked_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'blocked' }
  has_many :blocked_friends, through: :blocked_user_friendships, source: :friend
  
  has_many :accepted_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'accepted' }
  has_many :accepted_friends, through: :accepted_user_friendships, source: :friend
  
  
  validates :first_name, presence: true  
  validates :last_name, presence: true 
  validates :profile_name, presence: true,uniqueness: true,format: {
																	with: /^[a-zA-Z0-9_-]+$/,
																	message: "Must be formatted correctly"
																	}  
  has_attached_file :avatar
  # has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  has_attached_file :avatar, styles: {
    large: "800x800>", medium: "300x200>", small: "260x180>", thumb: "80x80#"
  }
	#validates_attachment :image#, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  #do_not_validate_attachment_file_type :avatar
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  
  def self.get_gravatars
    all.each do |user|
      if !user.avatar?
        user.avatar = URI.parse(user.gravatar_url)
        user.save
        print "."
      end
    end
  end
  
  
  def user_params
	  params.require(:user).permit(:avatar)
  end
  
  def full_name
	first_name + " "+ last_name
  end
  
  # to_param is a rails method to link the object instead of using object id more info at this url => https://gist.github.com/cdmwebs/1209732
  def to_param
	profile_name
  end
  # end to_param
  
  def gravatar_url
	stripped_email = email.strip
	downcased_email = stripped_email.downcase
	hash = Digest::MD5.hexdigest(downcased_email)
	"http://gravatar.com/avatar/#{hash}"
  end
  
  def your_questions(params)
	questions.paginate(page: params[:page],per_page: 2).order('created_at DESC')		
  end
  
  def has_blocked?(other_user)
	blocked_friends.include?(other_user)  
  end
  
end
