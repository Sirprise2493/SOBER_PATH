class CreateAiChatMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :ai_chat_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :is_ai_message, null: false, default: false
      t.text    :message_content, null: false
      t.timestamps
    end

    add_index :ai_chat_messages, :is_ai_message
  end
end
