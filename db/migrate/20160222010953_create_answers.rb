class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question, null: false, index: true
      t.text :body
      t.timestamps null: false
    end
  end
end
