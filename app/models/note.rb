class Note < ApplicationRecord
  belongs_to :schoolwork

  validates :content, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
