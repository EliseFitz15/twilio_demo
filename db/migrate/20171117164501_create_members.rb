class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.string :client_member_id, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.date :date_of_birth, null: false
      t.string :gender, limit: 1, null: false
      t.timestamps
    end
  end
end
