require 'rails_helper'

feature 'User can logout', "
	In order to end the user session
	As an authenticated user
	I'd like to be able to logout
" do
  given(:user) { create(:user) }

  background { sign_in(:user) }

  scenario 'Authenticated want to logout' do
    click_on 'Sign_out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
