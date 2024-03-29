class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, null: false, index: true
      t.references :post, null: false, index: true
      t.text :body
      t.timestamps null: false
    end
  end
end
