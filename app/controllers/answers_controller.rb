class AnswersController < ApplicationController 
  before_action :authenticate_user!, except: %i[show] 
  before_action :set_answer, only: %i[show destroy]
  
  def index; end

  def new; end  

  def show; end  

  def create 
    question = Question.find(params[:question_id])

    @answer = question.answers(answer_params)
    @answer.user = current_user

    if @answer.save  
      redirect_to question_answers_path  
    else  
      render :new 
    end
  end  

  def edit;end 

  def update; end 

  def destroy
    if current_user&.author?(@answer) 
      @answer.destroy
      redirect_to question_path(@answer.question), notice: "answer deleted" 
    else 
      redirect_to question_path(@answer.question) 
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
