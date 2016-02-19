class AddTitleUniqueIndexToIssues < ActiveRecord::Migration
  def change
    remove_index :issues, :title
    add_index :issues, :title, unique: true
  end
end
