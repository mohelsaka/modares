class AddTypeToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :question_type, :string, :default => 'multiple_choice'
  end
end
