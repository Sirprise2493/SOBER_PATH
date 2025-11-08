class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :username, null: false
      t.date    :date_of_birth, null: false
      t.string  :address
      t.string  :email, null: false
      t.string  :headline
      t.text    :bio
      t.date    :sobriety_start_date
      t.boolean :counsellor, null: false, default: false

      # Moderation/Posting-Rechte
      t.datetime :messaging_suspended_until
      t.integer  :strike_count, null: false, default: 0

      t.timestamps
    end

    add_index :users, "LOWER(username)", unique: true, name: "index_users_on_lower_username"
    add_index :users, "LOWER(email)",    unique: true, name: "index_users_on_lower_email"
  end
end
