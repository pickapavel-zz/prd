class CreatePartnerships < ActiveRecord::Migration[5.0]
  def change
    create_table :partnerships do |t|
      t.integer :partner_id
      t.integer :client_id
      t.timestamps
    end
  end
end
