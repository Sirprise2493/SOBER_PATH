class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home; end

  def meetings
    # Map Simple Form nested params to flat keys
    if params[:search].present?
      params[:address]   = params[:search][:address]
      params[:radius_km] = params[:search][:radius_km]
    end

    # Radius as float, clamp 0.3..50.0
    @radius_km = params[:radius_km].presence ? params[:radius_km].to_f : 20.0
    @radius_km = @radius_km.clamp(0.3, 50.0)

    start_address = params[:address].presence || current_user&.address

    # Determine center (geocode)
    @center_lat = @center_lng = @center_label = nil
    if start_address.present?
      if (geo = Geocoder.search(start_address).first)
        @center_lat  = geo.latitude
        @center_lng  = geo.longitude
        @center_label = start_address
      end
    end

    # Fallback: first venue
    if @center_lat.blank? || @center_lng.blank?
      if (first = AaVenue.geocoded.first)
        @center_lat  = first.latitude
        @center_lng  = first.longitude
        @center_label = [first.street, first.zip, first.city].compact_blank.join(", ")
      end
    end

    # Venues within radius (sorted by distance) or all geocoded if no center
    @venues =
      if @center_lat && @center_lng
        AaVenue.near([@center_lat, @center_lng], @radius_km, units: :km).order("distance")
      else
        AaVenue.geocoded
      end

    # Build markers for Mapbox
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

    # New venues
    @venue = AaVenue.new
    @venue.aa_meetings.new
  end

  def chatroom
    @ai_chat_messages = current_user.ai_chat_messages.order(created_at: :desc).limit(30).to_a.reverse
    @ai_chat_message = AiChatMessage.new
  end

  def journal
    @today = Time.zone.today

    @date =
      if params[:date].present?
        begin
          Date.parse(params[:date])
        rescue ArgumentError
          @today
        end
      else
        @today
      end

    range = @date.beginning_of_day..@date.end_of_day

    # Eintrag für dieses Datum (falls vorhanden)
    @journal_content = current_user.journal_contents.where(created_at: range).first

    # Nur für HEUTE: neuen Eintrag vorbereiten, wenn noch keiner existiert
    if @journal_content.nil? && @date == @today
      @journal_content = current_user.journal_contents.build
    end
  end

  def milestones
    @all_ai_messages = current_user.ai_chat_messages.count
    @all_journal_entries = current_user.journal_contents.count
    @all_user_chat_messages = current_user.user_chat_messages.count
    @all_user_chat_messages_responses = current_user.user_chat_messages_responses.count

    @pie_data = {
      "AI Messages"         => @all_ai_messages,
      "User Chat Messages"  => @all_user_chat_messages,
      "Journal Entries"     => @all_journal_entries,
      "User Chat Responses" => @all_user_chat_messages_responses
    }

    @friends_count = Friendship.where(status_of_friendship_request: 1)
    .where("asker_id = :user_id OR receiver_id = :user_id", user_id: current_user.id).count

    @username = current_user.username
  end
end
