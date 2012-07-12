class AddPositionToLevelsAndSemesters < ActiveRecord::Migration
  def change
    add_column :levels, :position, :integer
    add_column :semesters, :position, :integer
  end
end
