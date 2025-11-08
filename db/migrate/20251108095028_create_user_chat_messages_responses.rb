class CreateUserChatMessagesResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :user_chat_messages_responses do |t|
      t.references :user,               null: false, foreign_key: true
      t.references :user_chat_message,  null: false, foreign_key: true
      t.text :message_content, null: false
      t.timestamps
    end
  end
end
