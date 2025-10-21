class CreatePets < ActiveRecord::Migration[7.2]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :species
      t.integer :age
      t.text :description
      t.boolean :adopted

      t.timestamps
    end
  end
end
