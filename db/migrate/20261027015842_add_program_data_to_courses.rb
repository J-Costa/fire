class AddProgramDataToCourses < ActiveRecord::Migration[8.1]
  def change
    add_column :courses, :program_data, :jsonb, null: false, default: {}
  end
end
