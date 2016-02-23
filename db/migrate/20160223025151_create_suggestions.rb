class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.references :problem, null: false, index: true
      t.text :body
      t.timestamps null: false
    end
  end
end
