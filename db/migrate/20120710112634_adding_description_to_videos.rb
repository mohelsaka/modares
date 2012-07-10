class AddingDescriptionToVideos < ActiveRecord::Migration
  def up
    add_column :videos, :description, :string
  end

  def down
  end
end
