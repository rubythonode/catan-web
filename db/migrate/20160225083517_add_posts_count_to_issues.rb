class AddPostsCountToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :posts_count, :integer, default: 0
  end
end
