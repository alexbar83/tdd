require 'rails_helper'

feature 'User can add links to question', %q{
  In order to ask question
  As an unauthenticated user
  I'd like to be able to add links
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user)}
  given!(:link) {create(:link, linkable :question, name: 'stackoverflow', url: "https://stackoverflow.com"}

 
    end 
    scenario 'user edit link', js: true  do
      within '.question' do
        click_on "Edit question"
      end 

      within_all('.nested-fields').last do
        fill_in 'Link name', with: 'overflow'
        fill_in 'Url', with: "https://stackoverflow.com/4141" 
      end 

      click_on "Save"
    end
    within '.question' do
      expect(page).to_not have_content link.name
      expect(page).to_not have_content link.url 
      expect(page).to have_link('overflow', href: "https://stackoverflow.com/4141")
    end 
  end 
  scenario 'user ask with link err'  do
    within '.question' do
      click_on "Edit question"
      
      within '.link' do
      click_on "Add link"
    end 

    within_all('.nested-fields').first do
      fill_in 'Link name', with: 'stackoverflow'
      fill_in 'Url', with: "link" 
    end

    click_on "Save" 
  end

      expect(page).to_not have_link "stackoverflow" , href: "link"
      expect(page).to have_content "Link url is not valid" 
    end 
  end

  describe "Unauthenticated user want edit link when asks question" do
    background do 
      sign_in(user) 
      visit question_path(question.id) 
    end 
    
    scenario 'unauthenticated user  link'  do
      expect(page).to_not have_link "Edit question" 
    end 
  end
end 
