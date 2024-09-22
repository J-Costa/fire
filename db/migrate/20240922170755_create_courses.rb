class CreateCourses < ActiveRecord::Migration[7.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :featured

      t.timestamps
    end
  end
end
