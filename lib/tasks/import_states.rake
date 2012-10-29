desc "Import states"

task :import_states => :environment do
  states = File.read("states.txt")
  states.each_line do |line|
    g = Geography.new
    g.parent_id = 1
    g.name = line
    g.save
  end
end
