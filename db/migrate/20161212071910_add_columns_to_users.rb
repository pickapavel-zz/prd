class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.integer :role, default: 0
      t.string :team
    end
  end
end
