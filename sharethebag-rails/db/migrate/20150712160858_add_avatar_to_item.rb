class AddAvatarToItem < ActiveRecord::Migration
  def change
    add_column :items, :avatar, :string
  end
end
