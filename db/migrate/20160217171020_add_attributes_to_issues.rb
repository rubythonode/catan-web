class AddAttributesToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :body, :text
    add_column :issues, :logo, :string
    add_column :issues, :cover, :string
  end
end
