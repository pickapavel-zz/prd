class CreateLoanApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :loan_applications do |t|
      t.decimal :limit
      t.integer :duration
      t.decimal :interest
      t.decimal :payment
      t.decimal :apr
      t.integer :client_id
      t.boolean :security
      t.timestamps
    end
  end
end
