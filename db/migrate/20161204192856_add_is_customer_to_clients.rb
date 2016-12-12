class AddIsCustomerToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :non_customer, :boolean, default: false
  end
end
