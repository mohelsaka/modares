class AddCorrectAnswerColumnToAnswers < ActiveRecord::Migration
  def change
    # this column contains information about the correct answer
    # e.g. if the parent question was mulipple question then this contaitns a flag (true|false)
    # if the parent question was short answer question, then it will contain the correct answer
    add_column :answers, :correct_answer, :string
  end
end
