class CreateAaVenues < ActiveRecord::Migration[7.1]
  def change
    create_table :aa_venues do |t|
      t.string  :name, null: false
      t.string  :street
      t.string  :city
      t.string  :zip
      t.string  :country, default: "DE"
      t.decimal :latitude,  precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string  :website_url
      t.text    :notes
      t.timestamps
    end

    add_index :aa_venues, [:latitude, :longitude]
    add_index :aa_venues, [:city, :zip]
  end
end
