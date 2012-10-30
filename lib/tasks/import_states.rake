desc "Import states"

task :import_states => :environment do
  states = File.read("states.csv")
  states.each_line do |line|
    line = line[0..-2]
    l = line.split(',')
    g = Geography.new
    g.parent_id = 1
    g.name = l[0]
    g.abbreviation = l[1]
    g.save
  end
end
