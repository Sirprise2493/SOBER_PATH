module EncouragementsHelper
  def format_encouragement_reason(reason)
    return "" if reason.blank?

    str = reason.to_s
    downcased = str.downcase

    return "Birthday" if downcased == "birthday"

    if downcased.start_with?("milestone:")
      raw_value = str.split(":", 2).last || ""
      value = raw_value.strip
      return "#{value} milestone"
    end

    str.titleize
  end

  def encouragement_timestamp(encouragement)
    time =
      if current_user&.time_zone.present?
        encouragement.created_at.in_time_zone(current_user.time_zone)
      else
        encouragement.created_at.in_time_zone
      end

    today     = Time.zone.today
    date      = time.to_date

    label =
      if date == today
        "Today"
      elsif date == today - 1
        "Yesterday"
      else
        I18n.l(date, format: :short) # e.g. "29 Nov"
      end

    "#{label} · #{time.strftime('%H:%M')}"
  end
end
