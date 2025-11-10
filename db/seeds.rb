# db/seeds.rb
require "faker"

Faker::Config.locale = "en"

puts "==> Cleaning up existing data…"
# Order matters due to FKs
UserChatMessagesResponse.delete_all
UserChatMessage.delete_all
Friendship.delete_all
AiChatMessage.delete_all
JournalContent.delete_all
User.delete_all

# Reset PK sequences (Postgres/SQLite)
def reset_pk!(model)
  if ActiveRecord::Base.connection.respond_to?(:reset_pk_sequence!)
    ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
  end
end
[User, JournalContent, AiChatMessage, Friendship, UserChatMessage, UserChatMessagesResponse].each { |m| reset_pk!(m) }

puts "==> Creating users…"
Faker::UniqueGenerator.clear # falls Seeds erneut laufen

N_USERS = 30
users = Array.new(N_USERS) do |i|
  first = Faker::Name.first_name
  last  = Faker::Name.last_name

  # Username: nur Buchstaben, Ziffern, Unterstrich (deine Validierung)
  base = "#{first}_#{last}".downcase
  uname = base.gsub(/[^a-z0-9_]/, "_").gsub(/_+/, "_")[0..31]
  # Falls schon vorhanden (case-insensitive), häng Index an
  if User.where("LOWER(username) = ?", uname.downcase).exists?
    uname = "#{uname}_#{i}"
    uname = uname[0..31]
  end

  User.create!(
    first_name: first,
    last_name:  last,
    username:   uname,
    date_of_birth: Faker::Date.birthday(min_age: 20, max_age: 65),
    address:    Faker::Address.full_address,
    email:      Faker::Internet.unique.email(name: "#{first}.#{last}"),
    headline:   ["On the path", "One day at a time", "Staying strong"].sample,
    bio:        Faker::Lorem.paragraph(sentence_count: 3),
    sobriety_start_date: Faker::Date.between(from: 400.days.ago, to: Date.today),
    counsellor: (i % 10 == 0), # ~10% are counsellors
    # Moderation
    strike_count: [0, 0, 0, 1].sample,
    messaging_suspended_until: (rand < 0.08 ? 2.days.from_now : nil),

    # Devise-Pflichtfelder
    password: "Test1234!",
    password_confirmation: "Test1234!"
  )
end

puts "==> Creating journal entries…"
users.each do |u|
  rand(2..5).times do
    JournalContent.create!(
      user: u,
      content: Faker::Lorem.paragraphs(number: rand(2..6)).join("\n\n"),
      motivational_text: [
        "You’ve got this.",
        "One day at a time.",
        "Breathe. Write. Keep going."
      ].sample
    )
  end
end
while JournalContent.count < 10
  JournalContent.create!(user: users.sample, content: Faker::Lorem.paragraph, motivational_text: "Keep going!")
end

puts "==> Creating AI chat transcripts…"
USER_PROMPTS = [
  "It's hard to stay sober today.",
  "I just reached 30 days!",
  "Cravings are stronger in the evening.",
  "I slipped yesterday and feel ashamed.",
  "How do I handle a party invitation?"
]

AI_RESPONSES = [
  "Thanks for sharing. Urges pass—try a 10-minute distraction and check in afterward.",
  "Congrats on 30 days! Celebrate safely and note what helped you get here.",
  "Evenings are tough; plan a short routine for that window and message a buddy.",
  "Be kind to yourself. One lapse isn’t a collapse; what’s one thing you learned?",
  "If you go, bring support and an exit plan. If not, suggest an alternative."
]

users.each do |u|
  # 5 Konversationen pro User: je eine Zeile mit user message + ai_answer
  5.times do
    prompt = USER_PROMPTS.sample || Faker::Lorem.sentence(word_count: 12)
    answer = AI_RESPONSES.sample || Faker::Lorem.sentence(word_count: 16)
    AiChatMessage.create!(
      user: u,
      message_content: prompt,
      ai_answer: answer
    )
  end
end
# Fallback: mindestens 10 Datensätze
while AiChatMessage.count < 10
  AiChatMessage.create!(
    user: users.sample,
    message_content: Faker::Lorem.sentence(word_count: 10),
    ai_answer: Faker::Lorem.sentence(word_count: 16)
  )
end

puts "==> Creating friendships…"
pairs = users.combination(2).to_a.sample(80) # bis zu 80 Versuche
states = [0, 0, 1, 2] # mehr pending als andere
pairs.each do |a, b|
  begin
    Friendship.create!(
      asker: [a, b].sample,
      receiver: [a, b].reverse.sample, # ensure not self
      status_of_friendship_request: states.sample
    )
  rescue ActiveRecord::RecordInvalid
    next
  end
end
while Friendship.count < 10
  a, b = users.sample(2)
  next if a == b
  Friendship.create!(asker: a, receiver: b, status_of_friendship_request: states.sample) rescue nil
end

puts "==> Creating chatroom messages…"
eligible_posters = users.select { |u| u.messaging_suspended_until.nil? || u.messaging_suspended_until < Time.current }
50.times do
  u = eligible_posters.sample || users.sample
  UserChatMessage.create!(
    user: u,
    message_content: [
      "Sharing today: #{Faker::Lorem.sentence(word_count: 10)}",
      "Today's triggers: #{Faker::Lorem.words(number: 5).join(', ')}",
      Faker::Lorem.paragraph(sentence_count: 2)
    ].sample
  ) rescue next
end
while UserChatMessage.count < 10
  u = eligible_posters.sample || users.sample
  UserChatMessage.create!(user: u, message_content: Faker::Lorem.paragraph) rescue nil
end

puts "==> Creating responses to chatroom messages…"
UserChatMessage.find_each do |msg|
  rand(0..3).times do
    UserChatMessagesResponse.create!(
      user: users.sample,
      user_chat_message: msg,
      message_content: [
        "Thanks for sharing. Keep going!",
        "I relate to this — stay strong 💪",
        Faker::Lorem.sentence(word_count: 12)
      ].sample
    )
  end
end
while UserChatMessagesResponse.count < 10
  UserChatMessagesResponse.create!(
    user: users.sample,
    user_chat_message: UserChatMessage.order(Arel.sql("RANDOM()")).first || UserChatMessage.first,
    message_content: Faker::Lorem.sentence
  ) rescue nil
end

puts "==> Summary:"
puts "Users:                      #{User.count}"
puts "JournalContents:            #{JournalContent.count}"
puts "AiChatMessages:             #{AiChatMessage.count}"
puts "Friendships:                #{Friendship.count}"
puts "UserChatMessages:           #{UserChatMessage.count}"
puts "UserChatMessagesResponses:  #{UserChatMessagesResponse.count}"
puts "DONE ✅"
