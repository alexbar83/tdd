require 'rails_helper'

feature 'User can write answers for question', %q{
  In order to write answers to question
  As an authenticated user
  I'd like to be able to write and answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user}

  describe 'Authenticated user can write answer' do
    background do
      sign_in(user)

      visit questions_path(question.id)
    end

    scenario 'write an answer', js: true do
      fill_in 'answer[body]', with: 'text text text'
      click_on 'Write answer'
      expect(current_path).to eq question_path(question)
        within '.answers' do 
      expect(page).to have_content 'text text text' 
      end
    end

     scenario 'asks a answer with attached file' do
      fill_in 'answer[body]', with: 'text text text'
     

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
  context 'multiple sessions' do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer[body]', with: 'text text text'
        click_on 'Create'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
      end
    end
  end
  scenario 'Unauthenticated user tries to write an answer' do  
    visit questions_path(question.id)
    click_on 'Sign in write an answer' 

    expect(page).to have_content 'log in'
  end 

  scenario 'write answer with errors', js: true do 
    sign_in(user)
    visit questions_path(question.id)
    click_on 'Write answer'

    expect(page).to have_content 'Body can not be blank'
  end
end
