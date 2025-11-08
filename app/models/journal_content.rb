class JournalContent < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 1000 }
  validates :motivational_text, length: { maximum: 50 }, allow_blank: true
end
