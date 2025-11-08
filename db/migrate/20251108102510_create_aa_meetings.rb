class CreateAaMeetings < ActiveRecord::Migration[7.1]
  def change
    create_table :aa_meetings do |t|
      t.references :aa_venue, null: false, foreign_key: true
      t.integer :weekday, null: false, default: 0   # 0 = Sunday
      t.time    :starts_at, null: false
      t.time    :ends_at
      t.boolean :is_online, null: false, default: false
      t.string  :online_url
      t.timestamps
    end

    add_index :aa_meetings, [:aa_venue_id, :weekday, :starts_at], name: "idx_meetings_schedule"
  end
end
