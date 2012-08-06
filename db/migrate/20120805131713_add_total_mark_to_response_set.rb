class AddTotalMarkToResponseSet < ActiveRecord::Migration
  def change
    add_column :response_sets, :total_mark, :integer
  end
end
