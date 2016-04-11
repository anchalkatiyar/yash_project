class Status < ActiveRecord::Base

	attr_accessible :content, :user_id, :document_attributes#, :name 
	belongs_to :user
	belongs_to :document

	accepts_nested_attributes_for :document
	validates :content, presence: true , length: {minimum: 2}
	#validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }
	#validates_attachment_content_type :attachment, :content_type => ['image/png', 'image/jpeg', 'image/jpg', 'image/gif']
	validates :user_id , presence: true
	self.per_page = 5
	
	
	
end
