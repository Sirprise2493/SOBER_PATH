require "open-uri"

class JournalContentJob < ApplicationJob
  queue_as :default

  def perform(journal_content_id, regenerate_only_photo: false)
    @journal_content = JournalContent.find(journal_content_id)

    access_token = ENV.fetch("OPENAI_ACCESS_TOKEN") # <- correct for ruby-openai
    client = OpenAI::Client.new(access_token: access_token)

    unless regenerate_only_photo
      @journal_content.motivational_text = generate_motivational_text(client, @journal_content.content)
    end

    begin
      generate_and_attach_photo(client, @journal_content)
    rescue Faraday::ForbiddenError => e
      Rails.logger.error "OpenAI 403 for images: #{e.message}"
      # optional: store a small note
      @journal_content.motivational_text ||= ""
      @journal_content.motivational_text += " (Image could not be generated.)"
    end

    @journal_content.save!
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
    journal_content.photo.purge if journal_content.photo.attached?
    journal_content.photo.attach(
      io: file,
      filename: "journal-#{journal_content.id}.png",
      content_type: "image/png"
    )
  end
end
