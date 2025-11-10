class SwapIsAiMessageForAiAnswer < ActiveRecord::Migration[7.1]
  def change
    remove_index :ai_chat_messages, :is_ai_message if index_exists?(:ai_chat_messages, :is_ai_message)
    remove_column :ai_chat_messages, :is_ai_message, :boolean, default: false, null: false
    add_column :ai_chat_messages, :ai_answer, :text
  end
end
