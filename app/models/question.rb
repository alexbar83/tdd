class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  scope :daily_mail, -> { where(created_at: Date.today.all_day) }

  after_create :calculate_reputation

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
