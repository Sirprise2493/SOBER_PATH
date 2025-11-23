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
      @encouragement.update(read_at: Time.current)

      redirect_to milestones_path(
        sender_id: params[:sender_id].presence,
        enc_page:  (params[:enc_page].presence || 1)
      )
    end

  private

  def encouragement_params
    params.require(:encouragement).permit(:receiver_id, :body, :reason)
  end
end
