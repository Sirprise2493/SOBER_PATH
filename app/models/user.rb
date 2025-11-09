class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Relationships
  has_many :journal_contents, dependent: :destroy
  has_many :ai_chat_messages, dependent: :destroy
  has_many :user_chat_messages, dependent: :destroy
  has_many :user_chat_messages_responses, dependent: :destroy

  # Friendships (self join)
  has_many :friendships_sent, class_name: "Friendship", foreign_key: :asker_id, dependent: :destroy
  has_many :friendships_received, class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy

  has_many :friends_i_asked, -> { accepted }, through: :friendships_sent, source: :receiver
  has_many :friends_who_asked_me, -> { accepted }, through: :friendships_received, source: :asker

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..32 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :date_of_birth, presence: true

  #Attributes
  attribute :counsellor, :boolean, default: false
  attribute :strike_count, :integer, default: 0

  # Cöloudinary Avatar Picture
  has_one_attached :avatar

  def can_post_to_room?
    messaging_suspended_until.nil? || messaging_suspended_until < Time.current
  end

  # Nützliche Helfer
  def sobriety_days
    return 0 unless sobriety_start_date
    (Date.current - sobriety_start_date).to_i
  end
end
