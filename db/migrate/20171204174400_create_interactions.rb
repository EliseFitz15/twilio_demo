class CreateInteractions < ActiveRecord::Migration[5.1]
  def change
    create_table :interactions do |t|
      t.belongs_to :member, null: false
      t.string :interaction_type, null: false
      t.string :flow_type, null: false
      t.jsonb :conversation, null: false, default: {}

      t.timestamps
    end
    add_index :interactions, :conversation, using: :gin
  end
end
