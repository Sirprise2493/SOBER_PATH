class JournalContent < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 1000 }
  validates :motivational_text, length: { maximum: 50 }, allow_blank: true

  has_one_attached :photo

  def set_photo(regenerate_only_photo: true)
    JournalContentJob.perform_later(id, regenerate_only_photo: regenerate_only_photo)
  end

  after_create_commit do
    broadcast_prepend_later_to(
      [user, :journal_contents],
      target: "journal_contents",
      partial: "journal_contents/journal_content",
      locals: { journal_content: self }
    )
  end

  after_update_commit do
    broadcast_replace_later_to [user, :journal_contents]
  end
end
