class CreateCorporates < ActiveRecord::Migration[5.0]
  def change
    create_table :corporates do |t|
      t.boolean :is_owner
      t.string :name
      t.string :surname
      t.string :identification_no
      t.string :permanent_residence
      t.integer :client_id
      t.timestamps
    end
  end
end
