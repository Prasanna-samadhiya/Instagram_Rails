class ChangePhoneToStringInUsers < ActiveRecord::Migration[8.0]
  def change
     change_column :users, :phone, :string
  end
end
