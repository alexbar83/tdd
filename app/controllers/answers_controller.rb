class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_answer, only: %i[show destroy update best]

  def index; end

  def new; end

  def show; end

  def create
    @question = Question.find(params[:question_id])

    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
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
    if current_user&.author?(@answer)
      @answer.destroy
    else
      redirect_to @answer.question
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
