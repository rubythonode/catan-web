class AddUniqueSlugConstraintToIssue < ActiveRecord::Migration
  def change
    add_index :issues, :slug, unique: true
  end
end
