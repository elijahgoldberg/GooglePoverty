class CreateGeographies < ActiveRecord::Migration
  def change
    create_table :geographies do |t|
      t.string :name
      t.string :parent_id

      t.timestamps
    end
  end
end
