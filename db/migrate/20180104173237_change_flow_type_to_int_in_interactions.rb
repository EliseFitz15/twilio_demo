class ChangeFlowTypeToIntInInteractions < ActiveRecord::Migration[5.1]
  def up
    Interaction.all.destroy_all
    change_column :interactions, :flow_type, 'integer USING CAST(flow_type AS integer)'
  end

  def down; end
end
