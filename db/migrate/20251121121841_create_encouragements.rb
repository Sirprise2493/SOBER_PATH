class CreateEncouragements < ActiveRecord::Migration[7.1]
  def change
    create_table :encouragements do |t|
      t.references :sender,   null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.text       :body,     null: false
      t.datetime   :read_at

      t.timestamps
    end
  end
end
