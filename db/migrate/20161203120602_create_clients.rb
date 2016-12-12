class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :country
      t.string :zip
      t.string :ic
      t.string :surname
      t.string :legal_form
      t.string :title
      t.string :condition
      t.string :core_business
      t.date :registration_date
      t.string :record_id
      t.string :segment
      t.integer :user_id
      t.integer :hard_ko_criteria
      t.integer :soft_ko_criteria
      t.string :data_source
      t.boolean :consolidated
      t.date :last_updated
      t.timestamps
    end
  end
end
