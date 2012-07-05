class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name
      t.integer :parent_level_id
      t.string :description

      t.timestamps
    end
  end
end
