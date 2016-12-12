class AddSegmentTypeToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :segment_type, :integer, default: 0
  end
end
