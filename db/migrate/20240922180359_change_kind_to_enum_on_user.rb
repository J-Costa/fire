class ChangeKindToEnumOnUser < ActiveRecord::Migration[7.2]
  def up
    create_enum :user_kind, %w[admin student]

    change_column :users, :kind, :user_kind, using: 'kind::user_kind'
  end
end
