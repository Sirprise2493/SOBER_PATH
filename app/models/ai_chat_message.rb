class AiChatMessage < ApplicationRecord
  belongs_to :user
  validates :message_content, presence: true
  after_create :fetch_ai_answer

  private
  def fetch_ai_answer
    ChatbotJob.perform_later(self)
  end
end
