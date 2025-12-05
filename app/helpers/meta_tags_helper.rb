module MetaTagsHelper
  def meta_title
    if content_for?(:meta_title)
      content_for(:meta_title)
    else
      DEFAULT_META["meta_title"]
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
    meta_image = if content_for?(:meta_image)
                   content_for(:meta_image)
                 else
                   DEFAULT_META["meta_image"]
                 end

    # Works with an asset name ("sober-path-cover.png") or a full URL
    meta_image.to_s.start_with?("http") ? meta_image : image_url(meta_image)
  end
end
