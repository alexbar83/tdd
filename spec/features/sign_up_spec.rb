require 'rails_helper'

feature 'User can sign up', "
  In order to be a member
  As an unauthorized user
  I'd like to be able to sign up
" do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password_confirmation', with: '12345678'
    click_on 'Register'

    save_end_open_page
    expect(page).to have_content 'Welcome!You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password_confirmation', with: '12345678'
    click_on 'Register'

    expect(page).to have_content 'Email has already been taken'
  end
end
