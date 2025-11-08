class Friendship < ApplicationRecord
  belongs_to :asker,    class_name: "User"
  belongs_to :receiver, class_name: "User"

  enum status_of_friendship_request: { pending: 0, accepted: 1, declined: 2 }

  validates :asker_id, :receiver_id, presence: true
  validates :asker_id, uniqueness: { scope: :receiver_id,
                                     message: "hat bereits eine Anfrage an diesen User gestellt" }
  validate :not_self

  private

  def not_self
    errors.add(:receiver_id, "kann nicht dieselbe Person sein") if asker_id == receiver_id
  end
end
