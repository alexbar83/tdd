require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user)}
  given!(:link) {"https://stackoverflow.com"} 

  describe " user add linkwhen asks question", do
    background do 
      sign_in(user) 
      visit questions_path 
      click_on 'Ask question'
    end 
    scenario 'user asks with link',  do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'Add link'

      within_all('.nested-fields').last do
        fill_in 'Link name', with: 'stackoverflow'
        fill_in 'Url', with: link 
      end 

      click_on 'Ask'
   
      within'.question' do
        expect(page).to have_link('stackoverflow', href: "link")
      end
    end 
  
    scenario 'user ask with err link',  do 
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: "String"
      fill_in 'Url', with: "text"

      click_on 'Add link'

      within_all('.nested-fields').last do
        fill_in 'Link name', with: 'stackoverflow'
        fill_in 'Url', with: 'not-link' 
      end 

      click_on 'Ask'
      expect(page).to have_content 'Links url is not valid url'
    end
  end 
end 
