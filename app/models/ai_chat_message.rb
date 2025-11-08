class AiChatMessage < ApplicationRecord
  belongs_to :user
  validates :message_content, presence: true
  validates :is_ai_message, inclusion: { in: [true, false] }
end
