class AaVenuesController < ApplicationController
  before_action :set_venue, only: [:edit, :update, :destroy]

  def create
    @venue = AaVenue.new(venue_params)
    if @venue.save
      redirect_to meetings_path(anchor: "new-venue"), notice: "Venue created."
    else
      rebuild_meetings_page_state
      flash.now[:alert] = "Please fix the errors below."
      render "pages/meetings", status: :unprocessable_entity
    end
  end

  def edit
    @venue.aa_meetings.build if @venue.aa_meetings.empty?
    # Implicitly renders app/views/aa_venues/edit.html.erb (with the frame)
  end

  def update
    if @venue.update(venue_params)
      redirect_to meetings_path(anchor: "new-venue"), notice: "Venue updated."
    else
      @venue.aa_meetings.build if @venue.aa_meetings.empty?
      render :edit, status: :unprocessable_entity  # returns the frame-wrapped form
    end
  end

  def destroy
    @venue.destroy
    redirect_to meetings_path, notice: "Venue deleted."
  end

  private

  def set_venue
    @venue = AaVenue.find(params[:id])
  end

  def venue_params
    params.require(:aa_venue).permit(
      :name, :street, :zip, :city, :country, :website_url, :notes, :latitude, :longitude,
      aa_meetings_attributes: [:id, :weekday, :starts_at, :ends_at, :duration_minutes, :is_online, :online_url, :_destroy]
    )
  end

  # Minimal fallback – if create does not work
  def rebuild_meetings_page_state
    @radius_km = (params.dig(:search, :radius_km) || params[:radius_km] || 20).to_f.clamp(0.3, 50.0)
    first = AaVenue.geocoded.first
    @center_lat = first&.latitude
    @center_lng = first&.longitude
    @center_label = [first&.street, first&.zip, first&.city].compact_blank.join(", ")
    @venues  = AaVenue.geocoded
    @markers = @venues.map do |v|
      {
        lat: v.latitude,
        lng: v.longitude,
        info_window_html: ApplicationController.renderer.render(
          partial: "pages/meetings/info_window",
          formats: [:html],
          locals: { venue: v }
        )
      }
    end
  end
end
