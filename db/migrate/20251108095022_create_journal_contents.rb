class CreateJournalContents < ActiveRecord::Migration[7.1]
  def change
    create_table :journal_contents do |t|
      t.text    :content, null: false
      t.text    :motivational_text
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
