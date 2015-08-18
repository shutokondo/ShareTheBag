class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bagImage, :text
    add_column :users, :avatar, :text
    add_column :users, :message, :text
    add_column :users, :bagName, :string
  end
end
