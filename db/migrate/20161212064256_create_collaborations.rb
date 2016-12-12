class CreateCollaborations < ActiveRecord::Migration[5.0]
  def change
    create_table :collaborations do |t|
      t.integer :client_id
      t.integer :collaborator_id
      t.timestamps
    end
  end
end
