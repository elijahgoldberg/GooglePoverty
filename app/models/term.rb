class Term < ActiveRecord::Base
  attr_accessible :text, :level
  
  has_many :observations
  
  def testWrite
    File.open("sample.txt", 'w') {|f| f.write("Beautiful") }
  end
end
