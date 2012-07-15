class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.integer :views
      t.integer :user_id
      t.integer :subject_id

      t.timestamps
    end
  end
end
