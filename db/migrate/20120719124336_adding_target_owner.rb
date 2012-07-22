class AddingTargetOwner < ActiveRecord::Migration
  def up
    add_column :rs_evaluations, :target_owner_id, :integer
  end
end
