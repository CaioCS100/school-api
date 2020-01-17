class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.string :name
      t.string :father_name
      t.string :mother_name
      t.date :birth_date
      t.string :image

      t.timestamps
    end
  end
end
