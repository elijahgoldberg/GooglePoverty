class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.integer :term_id
      t.integer :geo_id
      t.string :range
      t.boolean :processed

      t.timestamps
    end
  end
end
