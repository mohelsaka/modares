class ConfirmedVideos < ActiveRecord::Migration
  def up
    add_column :videos, :confirmed, :boolean
  end

  def down
  end
end
