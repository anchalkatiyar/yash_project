class AnswersController < ApplicationController

	before_filter :auth, only:[:create]

	def create
		@question = Question.find(params[:question_id])
		@answer = @question.answers.build(params[:answer])
		@answer.user = current_user
		
		if @answer.save
			flash[:success] = "Answer Posted"
			#redirect_to root_url
			redirect_to @question
		else
			@question = Question.find(params[:question_id]) #used to correctly display of answer in show page of questions page to avoid blank display of answer
			render 'questions/show'
		end
	end

end
