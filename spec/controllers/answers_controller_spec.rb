require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user)}
  let(:question) { create(:question) }
  
  describe 'POST #create' do
    context 'with valid attributes' do 
      before { login(user) }

      it 'saves  answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer, question: question), question_id: question} }.to change(user.answers, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { answer: attributes_for(:answer, question: question), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do 
      before { login(user) } 

      it 'does not save the question' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid, question: question), question_id: question }.to_not change(question.answers,:count)
      end  

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question: question }, question_id: question

        expect(response).to render_template('questions/show')
      end
    end
  end 

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'user is an author'
      let!(:answer){ create(:answer, question: question, user: user)} 

      it 'deletes the answer' do 
        expect{ delete :destroy, params: { id: answer }}.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question
      end 
    end

    context 'user is not author' do 
      let(:not_author){ create(:user)}
      let(:question){ create(:question, user: not_author)}
      let!(:other_member_answer){ create(:answer, question: question, user: not_author } 

      it 'delete the answer' do 
        expect{ delete :destroy, params: { id: other_member_answer }}.to_not change(question.answers, :count)
      end

      it 'redirects to question' do  
        delete :destroy, params: { id: other_member_answer } 

        expect(response).to redirect_to questions_path(question)
      end
    end
  end 
end
