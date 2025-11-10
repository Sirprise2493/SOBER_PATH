# app/helpers/meetings_helper.rb
module MeetingsHelper
  def times_15min_collection
    (0...24*60).step(15).map do |m|
      t = Time.zone.parse("00:00") + m.minutes
      [t.strftime("%H:%M"), t.strftime("%H:%M")]
    end
  end

  def duration_collection
    [[30, "30 min"], [45, "45 min"], [60, "60 min"], [75, "75 min"], [90, "90 min"], [120, "120 min"]]
  end
end
