# app/helpers/meta_tags_helper.rb
module MetaTagsHelper
  def meta_title
    # 1. Hole entweder den per-page-Titel oder den Default
    title =
      if content_for?(:meta_title)
        content_for(:meta_title)
      else
        DEFAULT_META["meta_title"]
      end

    # 2. Fallback, falls leer oder zu kurz für den Test
    fallback = "Sober Path – Discreet online support community for alcohol recovery"

    title_str = title.to_s.strip

    if title_str.length < 21
      fallback
    else
      title_str
    end
  end

  def meta_description
    if content_for?(:meta_description)
      content_for(:meta_description)
    else
      DEFAULT_META["meta_description"]
    end
  end

  def meta_image
    meta_image =
      if content_for?(:meta_image)
        content_for(:meta_image)
      else
        DEFAULT_META["meta_image"]
      end

    meta_image.to_s.start_with?("http") ? meta_image : image_url(meta_image)
  end
end
