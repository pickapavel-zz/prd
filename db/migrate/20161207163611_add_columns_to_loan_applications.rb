class AddColumnsToLoanApplications < ActiveRecord::Migration[5.0]
  def change
    change_table :loan_applications do |t|
      t.string :title
      t.string :user_name
      t.integer :status, default: 0
    end
  end
end
