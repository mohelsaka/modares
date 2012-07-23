class RemoveAnswersQuestionsTables < ActiveRecord::Migration
  def up
    drop_table :answers
    drop_table :questions
  end

  def down
  end
end
