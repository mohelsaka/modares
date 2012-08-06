class AddCorrectFlageToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :correct_flag, :integer
  end
end
