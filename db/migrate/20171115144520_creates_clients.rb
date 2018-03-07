class CreatesClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false, unique: true
      t.timestamps null: false
    end
  end
end
