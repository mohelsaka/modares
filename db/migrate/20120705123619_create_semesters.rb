class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :name
      t.string :description
      t.integer :level_id

      t.timestamps
    end
  end
end
