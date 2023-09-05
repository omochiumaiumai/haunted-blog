# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }
  scope :visible_user, lambda { |user|
    if user.present?
      where('secret = ? OR user_id = ?', false, user.id)
    else
      where(secret: false)
    end
  }
  scope :search, lambda { |term|
    keyword = "%#{sanitize_sql(term)}%"
    where('title LIKE :search_term OR content LIKE :search_term', search_term: keyword)
  }

  scope :default_order, -> { order(id: :desc) }

  def owned_by?(target_user)
    user == target_user
  end
end
