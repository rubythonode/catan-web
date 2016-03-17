class AddNewBodyToArticles < ActiveRecord::Migration
  def up
    rename_column :articles, :body, :old_body
    add_column :articles, :body, :text

    query = "UPDATE articles SET body = '<p>' || title || '</p>' || old_body"
    ActiveRecord::Base.connection.execute query
    say query
  end

  def down
    remove_column :articles, :body
    rename_column :articles, :old_body, :body
    # raise "unimplemented"
  end
end
