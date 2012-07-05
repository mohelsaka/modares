class RemoveParentFromLevel < ActiveRecord::Migration
  def up
    remove_column :levels, :parent_level_id
  end

  def down
  end
end
