class AddAbbreviation < ActiveRecord::Migration
  def up
    change_table :geographies do |t|
      t.string :abbreviation, :default => false
    end
  end
end
