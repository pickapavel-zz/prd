class CreateFinancialIndicators < ActiveRecord::Migration[5.0]
  def change
    create_table :financial_indicators do |t|
      t.decimal :ebitda
      t.decimal :operating_id
      t.decimal :debt_service
      t.decimal :operating_dscr
      t.decimal :total_dscr
      t.integer :year
      t.integer :client_id
      t.timestamps
    end
  end
end
