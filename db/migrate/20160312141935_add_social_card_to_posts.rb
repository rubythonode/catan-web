class AddSocialCardToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :social_card, :string
  end
end
