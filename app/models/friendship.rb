class Friendship < ApplicationRecord
  belongs_to :asker,    class_name: "User"
  belongs_to :receiver, class_name: "User"

  enum status_of_friendship_request: { pending: 0, accepted: 1, declined: 2 }

  validates :asker_id, :receiver_id, presence: true
  validates :asker_id, uniqueness: { scope: :receiver_id,
                                     message: "hat bereits eine Anfrage an diesen User gestellt" }
  validate :not_self

  # friendships between two users, regardless of direction
  scope :between, ->(user_a, user_b) {
    where(asker: user_a, receiver: user_b).or(
      where(asker: user_b, receiver: user_a)
    )
  }

  private

  def not_self
    errors.add(:receiver_id, "kann nicht dieselbe Person sein") if asker_id == receiver_id
  end
end
