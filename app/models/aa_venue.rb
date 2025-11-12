class AaVenue < ApplicationRecord
  has_many :aa_meetings, dependent: :destroy, inverse_of: :aa_venue
  accepts_nested_attributes_for :aa_meetings, allow_destroy: true, reject_if: :all_blank

  # --- Validations ---
  validates :name, presence: true
  validates :website_url,
            allow_blank: true,
            format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  # Optional: require at least street OR city so geocoding makes sense.
  # Remove this if you truly want to allow empty location fields.
  validate :some_location_present, if: :should_geocode?

  # --- Geocoder ---
  geocoded_by :full_address, latitude: :latitude, longitude: :longitude
  after_validation :geocode, if: :should_geocode?

  # Optional: reset coordinates if the address is completely cleared,
  # to avoid stale coordinates.
  before_validation :clear_coords_if_address_blank

  # Build a flexible address from whatever parts are present.
  # Note: compact_blank requires Rails 6.1+. For older Rails versions:
  # [street, zip, city, country].compact.reject(&:blank?).join(", ")
  def full_address
    [street, zip, city, country].compact_blank.join(", ")
  end

  private

  # When should we geocode?
  # - on create if coordinates are missing
  # - when any address component changes
  # - only if at least one address component is present
  def should_geocode?
    address_present = street.present? || zip.present? || city.present? || country.present?
    creating_without_coords = new_record? && (latitude.blank? || longitude.blank?)
    address_changed =
      will_save_change_to_street?  ||
      will_save_change_to_zip?     ||
      will_save_change_to_city?    ||
      will_save_change_to_country?

    address_present && (creating_without_coords || address_changed)
  end

  # Optional validation: require at least street OR city
  def some_location_present
    if street.blank? && city.blank?
      errors.add(:base, "Please provide at least a street or a city to enable geocoding.")
    end
  end

  # Optional cleanup if all address fields are blank
  def clear_coords_if_address_blank
    if [street, zip, city, country].all?(&:blank?)
      self.latitude = nil
      self.longitude = nil
    end
  end
end
