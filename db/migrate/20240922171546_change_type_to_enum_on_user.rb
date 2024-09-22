class ChangeTypeToEnumOnUser < ActiveRecord::Migration[7.2]
  def up
    create_enum :user_type, %w[admin student]

    change_column :users, :type, :user_type, using: 'type::user_type'
  end

  def down
    change_column :users, :type, :string

    drop_enum :user_type
  end
end
