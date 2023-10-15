require 'rails_helper'

feature 'User can check his awards' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:award) { create(:award, :with_image, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'renders awards page' do
    sign_in(user)
    visit question_path(question)

    click_on 'Choose the best'
    visit awards_path

    expect(page).to have_content question.title
    expect(page).to have_content award.title
    expect(page).to have_selector 'img'
  end
end
