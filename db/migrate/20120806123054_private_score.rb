class PrivateScore < ActiveRecord::Migration
  def up
     add_column :users, :score_private, :boolean
  end

  def down
  end
end
