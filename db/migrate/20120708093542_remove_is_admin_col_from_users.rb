class RemoveIsAdminColFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :is_admin
  end

  def down
  end
end
