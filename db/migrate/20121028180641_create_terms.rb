class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :text
      t.integer :level
      t.integer :parent

      t.timestamps
    end
  end
end
