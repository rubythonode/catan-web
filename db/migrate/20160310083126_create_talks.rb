class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.references :issue, null: false, index: true
      t.references :user, null: false, index: true
      t.string :title, null: false
      t.text :body
      t.timestamps null: false
    end
  end
end
