require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:gist_url) {'https://gist.github.com/alexbar83/58655c2f62534746cbfb934b8fd289645f50'}
  given!(:link) {"https://stackoverflow.com"} 

  describe "authenticated user can write answer with", js: true do
    background do 
      sign_in(user) 
      visit question_path(question) 
    end 
  scenario 'write answer with link', js: true do
    fill_in 'answer[body]', with: 'text text text'

    click_on 'Add link'

    within_all('.nested-fields').first do
      fill_in 'Link name', with: 'stackoverflow'
      fill_in 'Url', with: link 
    end 

    click_on 'Create'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'text text text'
     
    within'.answers' do
      expect(page).to have_link('stackoverflow', href: "link")
    end
  end 
  
  scenario 'write answer with err link',  do
    fill_in 'answer[body]', with: 'text text text'

    fill_in 'Link name', with: "My gist"
    fill_in 'Url', with: "String"

    click_on 'Add link'

    within_all('.nested-fields').last do
      fill_in 'Link name', with: 'stackoverflow'
      fill_in 'Url', with: 'not-link' 
    end 

    click_on 'Create'
    expect(page).to have_content 'Links url is not valid url'
  end 
end 
