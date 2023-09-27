require 'rails_helper'

RSpec.describe User, type: :model do
  let(:users) { create(:user) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Author of question?' do
    let(:any_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'current user is author question' do
      expect(user).to be_author(question)
    end
    it 'current user not at author question' do
      expect(any_user).to_not be_author(question)
    end
  end

  describe 'Author of question?' do
    let(:any_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    it 'current user is author of answer' do
      expect(user).to be_author(answer)
    end
    it 'current user not at author answer' do
      expect(any_user).to_not be_author(answer)
    end
  end
end
