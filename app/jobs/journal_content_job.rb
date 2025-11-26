require "open-uri"

class JournalContentJob < ApplicationJob
  queue_as :default
  include ActionView::RecordIdentifier

  def perform(journal_content_id, regenerate_only_photo: false)
    @journal_content = JournalContent.find(journal_content_id)

    access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
    client = OpenAI::Client.new(access_token: access_token)

    unless regenerate_only_photo
      @journal_content.motivational_text =
        generate_motivational_text(client, @journal_content.content)
    end

    begin
      generate_and_attach_photo(client, @journal_content)
    rescue Faraday::ForbiddenError => e
      Rails.logger.error "OpenAI 403 for images: #{e.message}"
      @journal_content.motivational_text ||= ""
      @journal_content.motivational_text += " (Image could not be generated.)"
    end

    @journal_content.save!

    broadcast_ai_panel(@journal_content)
  end

  private

  def generate_motivational_text(client, content)
    prompt = <<~PROMPT
      Below is a personal journal entry.
      Write a very short motivating sentence in English
      with at most 50 characters.
      No emojis, no line breaks.

      Journal entry:
      "#{content}"
    PROMPT

    response = client.chat(
      parameters: {
        model: "gpt-4.1-mini",
        messages: [
          { role: "system", content: "You are an empathetic coach." },
          { role: "user",   content: prompt }
        ]
      }
    )

    text = response.dig("choices", 0, "message", "content").to_s.strip
    text.gsub(/\r?\n/, " ")[0...50]
  end

  def generate_and_attach_photo(client, journal_content)
    prompt = <<~PROMPT
      Create a friendly, calm image that fits the following journal entry:
      "#{journal_content.content}"
      Style: minimalistic illustrative artwork, positive mood.
      And don't add in any way liquors or beverages in the picture.
    PROMPT

    response = client.images.generate(
      parameters: {
        model: "dall-e-3",
        prompt: prompt,
        size: "1024x1024"
      }
    )

    url = response.dig("data", 0, "url")
    return unless url.present?

    file = URI.open(url)

    # WICHTIG: kein purge, damit der alte Blob nicht verschwindet,
    # bevor der neue Frame gerendert wurde → kein kaputtes Bild-Icon
    journal_content.photo.attach(
      io: file,
      filename: "journal-#{journal_content.id}.png",
      content_type: "image/png"
    )
  end

  def broadcast_ai_panel(journal_content)
    journal_content.broadcast_replace_to(
      [journal_content.user, :journal_contents],
      target: dom_id(journal_content, :ai_panel),
      partial: "journal_contents/ai_panel",
      locals: { journal_content: journal_content }
    )
  end
end
