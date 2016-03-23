class AddLinkSourceToArticles < ActiveRecord::Migration
  def change
    add_reference :articles, :link_source, index: true
  end
end
