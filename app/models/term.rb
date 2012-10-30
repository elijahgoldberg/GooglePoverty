class Term < ActiveRecord::Base
  attr_accessible :text, :level
  
  has_many :observations
  has_many :batches
  
end
