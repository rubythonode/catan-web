class AddCountsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :comments_count, :integer, default: 0
    add_column :posts, :votes_count, :integer, default: 0
  end
end
