class AddCountToVideoViews < ActiveRecord::Migration
  def change
    add_column :video_views , :views ,:integer
  end
end
