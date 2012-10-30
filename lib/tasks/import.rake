desc "Attempt to import and save CSV"

require 'net/http'
# 
# require 'net/http'
# Net::HTTP.start('static.flickr.com') { |http| 
   # resp = http.get('/92/218926700_ecedc5fef7_o.jpg')
      # open('fun.jpg', 'wb') { |file|
         # file.write(resp.body)
      # }
# }

task :import_csv => :environment do
  text = Net::HTTP.get('nytimes.com', '/index.html')
  File.open("test.txt", "w+") { |f| f.write(text) }
end
