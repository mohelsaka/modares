class DropVotes < ActiveRecord::Migration
  def up
    drop_table :votes
  end

  def down
  end
end
