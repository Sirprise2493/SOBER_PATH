class AaMeeting < ApplicationRecord
  belongs_to :aa_venue
  enum weekday: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }
  validates :weekday, :starts_at, presence: true
  validates :online_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true

  attr_accessor :duration_minutes

  before_validation :compute_ends_at_from_duration, if: -> { ends_at.blank? && duration_minutes.present? }

  private

  def compute_ends_at_from_duration
    return if starts_at.blank?
    base = starts_at.change(sec: 0) # Time on date “today” doesn’t matter for TIME type
    self.ends_at = base + duration_minutes.to_i.minutes
  end
end
