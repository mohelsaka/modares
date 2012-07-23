class CreateVideoAnswers < ActiveRecord::Migration
  def change
    create_table :video_answers do |t|
      t.string :body
      t.integer :user_id
      t.integer :video_question_id

      t.timestamps
    end
  end
end
