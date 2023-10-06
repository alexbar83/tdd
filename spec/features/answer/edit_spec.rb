require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do
  given(:author) { create(:users) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  
  scenario 'author edit his answer', js: true do
    sign_in(author)
    visit question_path(question)
    expect(page).to have_content "MyText"
    click_on 'Edit'


    within '.answers' do
      fill_in 'Your answer', with: 'edited answer'
      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'edits his answer with errors' do
    sign_in(author)
    visit questions_path(question)
    click_on 'Edit'

    expect(page).to have_content 'Body can not be blank'
  end 
  
  scenario "tries to edit other user's question" do
    sign_in(user)
    visit question_path(question) 

    expect(page).to_not have_link "Edit"
  end
end 
