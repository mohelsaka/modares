class AddIconToVideo < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.has_attached_file :icon
    end
  end
end
