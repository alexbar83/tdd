require 'rails_helper'

feature 'User can write answers for question', %q{
  In order to write answers to question
  As an authenticated user
  I'd like to be able to write and answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user}

  describe 'Authenticated user can write question' do
    background do
      sign_in(user)

      visit questions_path(question.id)
    end

    scenario 'write an answer' do
      fill_in 'answer[body]', with: 'text text text'
      click_on 'Write answer'

      expect(page).to have_content 'text text text'
    end
  end

  scenario 'Unauthenticated user tries to write an answer' do  
    visit questions_path(question.id)
    click_on 'Sign in write an answer' 

    expect(page).to have_content 'log in'
  end 

  scenario 'write answer with errors' do 
    sign_in(user)
    visit questions_path(question.id)
    click_on 'Write answer'

    expect(page).to have_content 'Body can not be blank'
  end
end
