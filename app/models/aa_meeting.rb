class AaMeeting < ApplicationRecord
  belongs_to :aa_venue
  enum weekday: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }
  validates :weekday, :starts_at, presence: true
  validates :online_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
end
