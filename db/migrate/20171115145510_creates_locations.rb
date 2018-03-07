class CreatesLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :customer_location_id, null: false
      t.string :name, null: false
      t.string :street_1, null: false
      t.string :street_2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.string :latitude, null: false
      t.string :longitude, null: false
      t.belongs_to :client, null: false

      t.timestamps null: false
    end
    add_index 'locations', %w[client_id name], unique: true
    add_index 'locations', %w[client_id customer_location_id], unique: true
  end
end
