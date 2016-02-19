class CreatePosts < ActiveRecord::Migration
  def up
    articles_count = ActiveRecord::Base.connection.execute "SELECT count(1) as count FROM articles"
    opinions_count = ActiveRecord::Base.connection.execute "SELECT count(1) as count FROM opinions"
    if articles_count[0]['count'] > 0 or opinions_count[0]['count'] > 0
      raise "Please destroy all articles and all opinions before migration!"
    end
    create_table :posts do |t|
      t.references :issue, null: false, index: true
      t.references :postable, null: false, index: true, polymorphic: true
      t.references :user, null: false, index: true
      t.timestamps null: false
    end

    remove_column :articles, :user_id
    remove_column :articles, :issue_id
    remove_column :opinions, :user_id
    remove_column :opinions, :issue_id
  end

  def down
    raise "unimplemented"
  end
end
