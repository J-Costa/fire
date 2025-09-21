class AddContactedToStudent < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :contacted, :boolean, default: false
  end
end
