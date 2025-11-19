class SobrietyMilestones
  MILESTONES = [
    { file: "0.png",  name: "New Start",  offset: { days: 0 } },
    { file: "1.png",  name: "24 hours",   offset: { days: 1 } },
    { file: "2.png",  name: "30 days",    offset: { days: 30 } },
    { file: "3.png",  name: "60 days",    offset: { days: 60 } },
    { file: "4.png",  name: "90 days",    offset: { days: 90 } },

    { file: "5.png",  name: "4 months",   offset: { months: 4 } },
    { file: "6.png",  name: "5 months",   offset: { months: 5 } },
    { file: "7.png",  name: "6 months",   offset: { months: 6 } },
    { file: "8.png",  name: "7 months",   offset: { months: 7 } },
    { file: "9.png",  name: "8 months",   offset: { months: 8 } },
    { file: "10.png", name: "9 months",   offset: { months: 9 } },
    { file: "11.png", name: "10 months",  offset: { months: 10 } },
    { file: "12.png", name: "11 months",  offset: { months: 11 } },

    { file: "13.png", name: "1 year",     offset: { years: 1 } },
    { file: "14.png", name: "2 years",    offset: { years: 2 } },
    { file: "15.png", name: "3 years",    offset: { years: 3 } },
    { file: "16.png", name: "5 years",    offset: { years: 5 } },
    { file: "17.png", name: "7 years",    offset: { years: 7 } },
    { file: "18.png", name: "10 years",   offset: { years: 10 } },
    { file: "19.png", name: "15 years",   offset: { years: 15 } },
    { file: "20.png", name: "20 years",   offset: { years: 20 } },
    { file: "21.png", name: "25 years",   offset: { years: 25 } },
    { file: "22.png", name: "30 years",   offset: { years: 30 } },
    { file: "23.png", name: "35 years",   offset: { years: 35 } },
    { file: "24.png", name: "40 years",   offset: { years: 40 } }
  ].freeze

  # All milestones the user has already reached
  def self.earned_for(user)
    return [] if user.sobriety_start_date.blank?

    today = Date.current

    MILESTONES.select do |milestone|
      reached_at = user.sobriety_start_date.advance(milestone[:offset])
      reached_at <= today
    end
  end

  # The latest milestone the user has reached (or nil)
  def self.current_for(user)
    earned_for(user).last
  end
end
