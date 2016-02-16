class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.references :user, null: false, index: true
      t.string :title, null: false
      t.text :body
      t.references :issue, null: false, index: true
      t.timestamps null: false
    end
  end
end
