class AddUniqueTitleConstraintToIssue < ActiveRecord::Migration
  def change
    add_index :issues, [:title, :deleted_at], unique: true
  end
end
