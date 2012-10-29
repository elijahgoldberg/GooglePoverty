class Observation < ActiveRecord::Base
  attr_accessible :end, :start, :term_id, :value, :geography_id
  
  belongs_to :geography
  belongs_to :term
  
  # Validations
  validates_presence_of :end, :start, :term_id, :value, :geography_id
  validates_uniqueness_of :term_id, :scope => [:end, :start, :geography_id]
end
