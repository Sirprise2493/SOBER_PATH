# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home; end

  def meetings
    # Simple Form -> flach spiegeln (falls genutzt)
    if params[:search].present?
      params[:address]   = params[:search][:address]
      params[:radius_km] = params[:search][:radius_km]
    end

    # Radius: Float, Default 20.0, clamp 0.3..50.0
    @radius_km = params[:radius_km].presence ? params[:radius_km].to_f : 20.0
    @radius_km = @radius_km.clamp(0.3, 50.0)

    start_address = params[:address].presence || current_user&.address

    # Mittelpunkt bestimmen (per Geocoder)
    @center_lat = @center_lng = @center_label = nil
    if start_address.present?
      if (geo = Geocoder.search(start_address).first)
        @center_lat  = geo.latitude
        @center_lng  = geo.longitude
        @center_label = start_address
      end
    end

    # Fallback: erstes Venue
    if @center_lat.blank? || @center_lng.blank?
      if (first = AaVenue.geocoded.first)
        @center_lat  = first.latitude
        @center_lng  = first.longitude
        @center_label = first.try(:address) || [first.street, first.zip, first.city].compact_blank.join(", ")
      end
    end

    # Venues innerhalb des Radius (km)
    @venues =
      if @center_lat && @center_lng
        AaVenue.near([@center_lat, @center_lng], @radius_km, units: :km)
      else
        AaVenue.geocoded
      end

    @markers = @venues.map do |venue|
      {
        lat: venue.latitude,
        lng: venue.longitude,
        info_window_html: render_to_string(
          partial: "pages/info_window",
          formats: [:html],
          locals: { venue: venue }
        )
      }
    end
  end


end
