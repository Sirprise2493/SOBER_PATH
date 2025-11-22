class User < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  after_validation :set_time_zone_from_coordinates, if: :will_save_change_to_address?
  # ---- Devise ----
  # :validatable adds presence/format/uniqueness for email.

  # devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # associations
  has_many :journal_contents,                dependent: :destroy
  has_many :ai_chat_messages,                dependent: :destroy
  has_many :user_chat_messages,              dependent: :destroy
  has_many :user_chat_messages_responses,    dependent: :destroy

  # friendships (self-join)
  has_many :friendships_sent,
           class_name: "Friendship",
           foreign_key: :asker_id,
           dependent: :destroy

  has_many :friendships_received,
           class_name: "Friendship",
           foreign_key: :receiver_id,
           dependent: :destroy

  has_many :friends_i_asked,
           -> { merge(Friendship.accepted) },
           through: :friendships_sent,
           source: :receiver

  has_many :friends_who_asked_me,
           -> { merge(Friendship.accepted) },
           through: :friendships_received,
           source: :asker
  
  #encouragements
  has_many :encouragements_sent,
           class_name: "Encouragement",
           foreign_key: :sender_id,
           dependent: :destroy

  has_many :encouragements_received,
           class_name: "Encouragement",
           foreign_key: :receiver_id,
           dependent: :destroy

  # files
  has_one_attached :avatar

  # normalization (before validations)
  before_validation :normalize_auth_fields

  def normalize_auth_fields
    self.email    = email.to_s.strip.downcase.presence
    self.username = username.to_s.strip.downcase.presence
  end

  # validations
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { in: 3..32 },
            format: { with: /\A[a-z0-9_]+\z/, message: "letters, digits, and underscore only" }

  validates :date_of_birth, presence: true
  validate  :must_be_adult, if: -> { date_of_birth.present? }

  validate :avatar_type

  # login via username or email
  attr_writer :login

  def login
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)&.downcase

    where(conditions.to_h).where(
      "LOWER(username) = :value OR LOWER(email) = :value",
      value: login
    ).first
  end

  # business logic / helpers

  def can_post_to_room?
    messaging_suspended_until.nil? || messaging_suspended_until < Time.current
  end

  def sobriety_days
    return 0 unless sobriety_start_date
    (Date.current - sobriety_start_date).to_i
  end

  def set_time_zone_from_coordinates
    return if latitude.blank? || longitude.blank?

    begin
      zone = Timezone.lookup(latitude, longitude)  # aus dem timezone-Gem
      self.time_zone = zone.name if zone
    rescue StandardError => e
      Rails.logger.error "Timezone lookup failed: #{e.class} - #{e.message}"
      self.time_zone ||= "Europe/Berlin"
    end
  end


  def current_coin_milestone
    SobrietyMilestones.current_for(self)
  end

  def earned_coin_milestones
    SobrietyMilestones.earned_for(self)
  end

  def next_coin_milestone_with_time
    SobrietyMilestones.next_for(self)
  end
  # friendships helpers
  
  # all accepted friends (both directions)
  def friends
    (friends_i_asked + friends_who_asked_me).uniq
  end

  # the friendship record between self and another user, if any
  def friendship_with(other_user)
    Friendship.between(self, other_user).first
  end

  def connected_with?(other_user)
    friendship = friendship_with(other_user)
    friendship&.accepted?
  end

  def pending_friend_request_for?(other_user)
    friendship = friendship_with(other_user)
    friendship&.pending?
  end

  def fullname
    [first_name, last_name].compact.join(" ").strip
  end

  private

  def must_be_adult
    if date_of_birth > 18.years.ago.to_date
      errors.add(:date_of_birth, "must be at least 18 years old")
    end
  end

  def avatar_type
    return unless avatar.attached?

    unless avatar.content_type&.start_with?("image/")
      errors.add(:avatar, "must be an image")
    end
  end
end
