class ChangeNullableTitleOfArticles < ActiveRecord::Migration
  def change
    change_column_null :articles, :title, true
  end
end
