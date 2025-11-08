class UserChatMessage < ApplicationRecord
  belongs_to :user
  has_many :user_chat_messages_responses, dependent: :destroy

  validates :message_content, presence: true, length: { maximum: 5_000 }
  validate  :user_has_posting_privileges

  private

  def user_has_posting_privileges
    errors.add(:base, "Your posting rights are currently locked!") unless user.can_post_to_room?
  end
end
