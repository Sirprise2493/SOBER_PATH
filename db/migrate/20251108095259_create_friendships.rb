class CreateFriendships < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships do |t|
      t.references :asker,    null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.integer :status_of_friendship_request, null: false, default: 0
      t.timestamps
    end

    add_index :friendships, [:asker_id, :receiver_id], unique: true
    add_check_constraint :friendships, "asker_id <> receiver_id", name: "chk_friendships_not_self"
  end
end
