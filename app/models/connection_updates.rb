class ConnectionUpdates
  Update = Struct.new(:kind, :friend, :date, :meta, keyword_init: true)

  def self.for(user, date: Date.current)
    new(user, date:).all
  end

  def initialize(user, date:)
    @user = user
    @date = date
    @friends = user.friends
  end

  def all
    (birthday_updates + sobriety_updates).sort_by { |u| u.friend.username }
  end

  private

  attr_reader :friends, :date

  def birthday_updates
    friends.filter_map do |friend|
      next if friend.date_of_birth.blank?
      next unless birthday_today?(friend.date_of_birth)

      Update.new(kind: :birthday, friend: friend, date: date, meta: {})
    end
  end

  def birthday_today?(dob)
    dob.month == date.month && dob.day == date.day
  end

  def sobriety_updates
    friends.flat_map do |friend|
      next [] if friend.sobriety_start_date.blank?

      milestones_today = SobrietyMilestones.reached_on(friend, date)
      milestones_today.map do |milestone|
        Update.new(
          kind:   :sobriety_milestone,
          friend: friend,
          date:   date,
          meta:   { milestone: milestone }
        )
      end
    end
  end
end
