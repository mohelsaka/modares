class AddWatchPercentToVideoViews < ActiveRecord::Migration
  def change
    add_column :video_views , :watch_percentage ,:integer
  end
end
