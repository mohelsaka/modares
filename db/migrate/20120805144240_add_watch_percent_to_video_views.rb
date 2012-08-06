class AddWatchPercentToVideoViews < ActiveRecord::Migration
  def change
    add_column :video_views, :watch_percentage, :float, :default => 0
  end
end
