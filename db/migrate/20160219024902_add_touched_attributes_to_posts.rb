class AddTouchedAttributesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :last_touched_action, :string, default: 'create'
    add_column :posts, :last_touched_params, :string
  end
end
