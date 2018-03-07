class AddMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships do |t|
      t.references :member, foreign_key: true
      t.references :location, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.timestamps
    end

    add_index 'memberships', %w[member_id location_id]
  end
end
