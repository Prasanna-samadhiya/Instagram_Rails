class AddRepliesToComments < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :replies, :string, array: true, default: []
  end
end
