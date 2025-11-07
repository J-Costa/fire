class AddsEnrolledToStudent < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :enrolled, :boolean, default: false, null: false
  end
end
