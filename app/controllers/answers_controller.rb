class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_answer, only: %i[show destroy update best]

  after_action :publish_answer, only: :create 

  authorize_resource

  def index; end

  def new; end

  def show; end

  def create
    @question = Question.find(params[:question_id])

    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def edit; end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def best
    if current_user.author?(@answer.question)
      @answer.best!
    else
      redirect_to @answer.question
    end
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Answer successfully deleted.'
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}",
      answer: @answer
    )
  end
end
