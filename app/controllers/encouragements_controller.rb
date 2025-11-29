class EncouragementsController < ApplicationController
  before_action :authenticate_user!

  def create
    @encouragement = Encouragement.new(encouragement_params)
    @encouragement.sender = current_user

    if @encouragement.save
      redirect_to chatroom_path(tab: "updates"),
                  notice: "Your encouragement was sent. 🌱"
    else
      redirect_back fallback_location: chatroom_path(tab: "updates"),
                    alert: @encouragement.errors.full_messages.to_sentence
    end
  end

  def show
    @encouragement = current_user.encouragements_received.find(params[:id])
    @encouragement.update!(read_at: Time.current)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          @encouragement,
          partial: "encouragements/encouragement",
          locals: { encouragement: @encouragement }
        )
      end

      format.html do
        redirect_to milestones_path(
          enc_page: (params[:enc_page].presence || 1)
        )
      end
    end
  end

  def destroy
    @encouragement = current_user.encouragements_received.find(params[:id])
    @encouragement.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@encouragement)
      end

      format.html do
        redirect_to milestones_path(
          enc_page: (params[:enc_page].presence || 1)
        ), notice: "Encouragement deleted."
      end
    end
  end

  private

  def encouragement_params
    params.require(:encouragement).permit(:receiver_id, :body, :reason)
  end
end
