class AddAboutMeUsers < ActiveRecord::Migration
  def up
    add_column :users , :about_me ,:string
  end

  def down
  end
end
