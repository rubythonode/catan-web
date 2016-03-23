class RenameLinkToLinkSources < ActiveRecord::Migration
  def change
    rename_table :links, :link_sources
  end
end
