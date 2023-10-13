require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do 
  given(:author) { create(:user)}
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user)}
  given!(:link) {create(:link, linkable :question, name: 'stackoverflow', url: "https://stackoverflow.com"} 

  describe " author remove link when asks question",js: true do
    background do 
      sign_in(author) 
      visit question_path(question.id) 
    end 
    scenario 'user delete link'  do
      click_on 'Edit question'
      
      within '.question' do
       click_on "Delete field"
      end 

      click_on "Save"

      expect(page).to_not have_content link.name
      expect(page).to_not have_content link.url
    end 
  end 
  
  describe "Unauthenticated user want remove link when asks question" do
    background do 
      sign_in(user) 
      visit question_path(question.id) 
    end 
    scenario 'user delete link'  do
      expect(page).to_not have_link "Edit question" 
    end 
  end
end 
