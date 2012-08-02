class AddVideoIdToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :video_id, :integer
  end
end
