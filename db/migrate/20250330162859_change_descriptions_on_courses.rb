class ChangeDescriptionsOnCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :details, :text
  end
end
