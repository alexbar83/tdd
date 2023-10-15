require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:questions) { create(:question, user: user) }
    let!(:awards) { create_list(:award, 1, :with_image, question: question, user: user) }

    before do
      login(user)
      get :index
    end

    it 'assingsawards to @awards' do
      expect(assigns(:awardss)).to eq awards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
