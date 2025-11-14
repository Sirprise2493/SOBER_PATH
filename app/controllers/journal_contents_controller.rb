class JournalContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_journal_content, only: %i[regenerate_photo]

def create
  @journal_content = current_user.journal_contents.build(journal_content_params)

  respond_to do |format|
    if @journal_content.save
      @journal_content.set_photo(regenerate_only_photo: false)

      format.html do
        redirect_to journal_path,
                    notice: "Photo and motivational text were created by AI."
      end

      format.turbo_stream
    else
      @date = Date.current

      format.html { render "pages/journal", status: :unprocessable_entity }
      format.turbo_stream
    end
  end
end


  def regenerate_photo
    # Regenerate only the photo
    @journal_content.set_photo # default: regenerate_only_photo: true
    redirect_to journal_path,
                notice: "The image is being regenerated."
  end

  private

  def set_journal_content
    @journal_content = current_user.journal_contents.find(params[:id])
  end

  def journal_content_params
    params.require(:journal_content).permit(:content)
  end
end
