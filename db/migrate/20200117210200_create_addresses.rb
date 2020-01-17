class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :cep
      t.string :street
      t.integer :number
      t.string :city
      t.string :uf
      t.string :complement
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
