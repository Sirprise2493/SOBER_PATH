class UserChatMessagesResponse < ApplicationRecord
  belongs_to :user
  belongs_to :user_chat_message

  validates :message_content, presence: true, length: { maximum: 800 }
end
