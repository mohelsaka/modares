class AddDurationToVideos < ActiveRecord::Migration
  def change
    # video duration in seconds
    add_column :videos, :duration, :integer, :default => 0
  end
end
