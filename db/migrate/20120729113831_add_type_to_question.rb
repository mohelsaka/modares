class AddTypeToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :question_type, :string, :default => 'paragraph_text'
  end
end
