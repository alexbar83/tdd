require 'rails_helper'

feature 'Authenticated user can edit his question', "
  In order to correct Question
  As an author of Question
  I'd like ot be able to edit my Question
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user trying edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario 'author trying to edit question with attached files', js: true do 
    sign_in(author)
    visit questions_path(question)
    click_on 'Edit Question' 

    within '.question' do
      attach_file 'question[files][]', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb' 
    end
  end


  scenario 'Author trying edit question', js: true do
    sign_in(author)
    visit question_path(question)

    click_on 'Edit question'

    within '.question' do
      fill_in 'question[title]', with: 'edited title'
      fill_in 'question[body]', with: 'edited body'
      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to_not have_selector 'textarea'
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
    end
  end

  scenario 'Author trying edit Question with errors', js: true do
    sign_in(author)
    visit question_path(question)

    click_on 'Edit question'

    within '.question' do
      fill_in 'question[title]', with: ' '
      fill_in 'question[body]', with: ' '
      click_on 'Save'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_selector 'textarea'
      expect(page).to have_button 'Save'
    end
  end

  scenario 'Member tries edit other users' do
    sign_in(userr)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end
