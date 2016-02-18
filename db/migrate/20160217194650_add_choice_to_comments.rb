class AddChoiceToComments < ActiveRecord::Migration
  def change
    add_column :comments, :choice, :string
  end
end
