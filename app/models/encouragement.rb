class Encouragement < ApplicationRecord
  belongs_to :sender,   class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :body, presence: true, length: { maximum: 500 }

  after_create_commit -> { broadcast_prepend_later_to [receiver, :encouragements] }
  after_update_commit -> { broadcast_replace_later_to [receiver, :encouragements] }
end
