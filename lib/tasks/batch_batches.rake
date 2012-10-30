desc "Batch create batches"

task :batch_batches => :environment do
  terms = Term.where("level = 1")
  geographies = Geography.all
  terms.each do |t|
    geographies.each do |g|
      #num = rand(7..17)
      #puts "...preparing next batch in #{num} sec"
      #sleep(num)
      term_id = t.id
      geography_id = g.id
      range = "all"
      b = Batch.new
      b.term_id, b.geography_id, b.range = term_id, geography_id, range
      b.save
      b.delay.pull
      #puts "Batch created. Geography: #{geography_id}, Term: #{term_id}"
    end
  end
end
