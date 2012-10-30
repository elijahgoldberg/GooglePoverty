class Geography < ActiveRecord::Base
  attr_accessible :name
  
  has_many :observations
  has_many :batches
  
  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name
  
end
