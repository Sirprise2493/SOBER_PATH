class AaVenue < ApplicationRecord
  has_many :aa_meetings, dependent: :destroy
  validates :name, presence: true
  validates :website_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true

  geocoded_by :full_address, latitude: :latitude, longitude: :longitude
  after_validation :geocode, if: -> { (will_save_change_to_street? || will_save_change_to_city? || will_save_change_to_zip? || will_save_change_to_country?) && (street.present? || city.present?) }

  def full_address
    [street, zip, city, country].compact_blank.join(", ")
  end
end
