class AddPhoneToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :phone, :string, limit: 11
  end
end
