class CreateInterfaceCaches < ActiveRecord::Migration[5.0]
  def change
    create_table :interface_caches do |t|
      t.string :ic
      t.text :source
      t.integer :kind
      t.timestamps
    end
  end
end
