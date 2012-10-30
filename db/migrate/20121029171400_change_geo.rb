class ChangeGeo < ActiveRecord::Migration
  def up
    remove_column :batches, :geo_id
    change_table :batches do |t|
      t.integer :geography_id, :default => false
    end
  end
end
