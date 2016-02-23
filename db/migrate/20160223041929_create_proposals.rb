class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.references :discussion, null: false, index: true
      t.text :body
      t.timestamps null: false
    end
  end
end
