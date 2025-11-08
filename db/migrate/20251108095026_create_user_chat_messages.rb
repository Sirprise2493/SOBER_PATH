class CreateUserChatMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :user_chat_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message_content, null: false
      t.timestamps
    end

    add_index :user_chat_messages, :created_at
  end
end
