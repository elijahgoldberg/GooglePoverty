class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.integer :term_id
      t.integer :value
      t.date :start
      t.date :end
      t.integer :geography_id

      t.timestamps
    end
  end
end
