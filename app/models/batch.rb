class Batch < ActiveRecord::Base
  attr_accessible :geography_id, :processed, :range, :term_id, :abbreviation
  
  # Associations
  belongs_to :geography
  belongs_to :term
  
  # Validations
  validates_presence_of :geography_id, :range, :term_id
  
  def testMethod
    puts "Sleeping 1..."
    sleep(1)
    puts "Sleeping 5..."
    sleep(5)
    puts "Sleeping 10.."
    sleep(10)
  end
  
  def pull
    num = rand(5..15)
    puts "Running next batch in #{num}.."
    sleep(num)
    geography_id, term_id, range, processed = self["geography_id"], self["term_id"], self["range"], self["processed"]
    geography = Geography.find(geography_id).abbreviation
    geo = "US-#{geography}"
    query = "0-#{term_id}"
    require 'net/http'
    uri_base = "http://www.google.com/trends/trendsReport?hl=en-US&cat=#{query}&geo=#{geo}&cmpt=q&content=1&export=1"
    uri = URI(uri_base)
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri.request_uri
      request['Accept-Charset'] = 'ISO-8859-1,utf-8'
      #request['Accept-Encoding'] = 'gzip,deflate,sdch'
      request['Accept-Language'] = 'en-US,en'
      request['Connection'] = 'keep-alive'
      request['Cookie'] = '__utma=173272373.578832817.1351569310.1351569310.1351569310.1; __utmb=173272373.9.10.1351572065; __utmc=173272373; __utmz=173272373.1351569310.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmv=173272373.|2=soph=categ=1; I4SUserLocale=en_US; __utma=173272373.578832817.1351569310.1351569310.1351569310.1; __utmb=173272373.10.9.1351573695726; __utmc=173272373; __utmz=173272373.1351569310.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmv=173272373.|2=soph=categ=1; SS=DQAAAMwAAAC1N6JRqprq_JLOjruZ6RwV9mihqas5o_1FsSLWXn-bgV1h6mzkbW8xRJKb3Lano2CcXfQ1367tC77F7-wjBAgKAAElwJF9tEJZdMTY8U1rRYBLSH6ldEfXO3ppxX8LJNiVwXrIGoqHoXi7YJ-zLdLlsTw3VskILKgKPBqoyJOm2xvOEtdk9wuLrscyDr169pdU19iPa3QhWpU-Sch8EkjZ_BtZblfvnWSvg_l-pwE__ZBus98djwrTEH8fNK6MNU3mhIReZVLXYwLejhPdzfry; NID=65=Jk0S2Bj9owjKiJ56cbytJrFrOqottoz_6k_oj6Ec1J7y4k4QMh6zxa66oBphMIbCjEROUq-CthQ9exE4TaByxR-FHI50CDG0CrGPEhNrM64t1_OHBkSNgZDBz50Y46pj35WQdx4xpOyHgxIDPccnbMwV-u_qgJMgPSR29aRwj38Qfw; HSID=Acej0iZoFSBUT09YT; APISID=90ulEK4q6h0sHZIl/ARpXHs0uyVFUs2bZ-; PREF=ID=e9c3c022af4a1950:U=891d03d1aa33bac8:FF=0:LD=en:TM=1351535883:LM=1351572746:GM=1:S=gkmY5V0_H56Y573H; SID=DQAAAMMAAACH8cz_VcVAAmLKSj4FZRmQ5mF5InvTNfaKweXbrjN5TYosbqvLkSFFSGz7HdKuuUO7kfqcYgVlxFjzVaCZvsd6MUtOI3YYg9M6fchuGA1u8qUdvS26PpZU-ogqXoYvS36vhS51kNfiBVHlfvCBMK-HjOmMulv6veU8QoQ9mJMmgyxSOx5svMvQtazmvYPGDk1JVvhtU6zzd1AW5xuo4q6tVUlAUZDamg99UbgKcNnxQCfUEew39Bfd5q6yyhVAFN6wrnnLu4PQtJCTyn5FxKnw; S=izeitgeist-ad-metrics=pgpHhHSENuQ'
      request['User-Agent'] = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.52 Safari/536.5'
      #request['Referer'] = 'http://www.google.com/trends/explore'
      request['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*'
      response = http.request request
      require 'csv'
      content = CSV.parse(response.body, :headers => false)
      result = process(content)
      "Success.  Batch #{id} run (Geography ID: #{geography_id}, Term ID: #{term_id}, Range: #{range})"
    end
  end
  
  def process(content)
    # Make the attributes easily accesssible
    geography_id, term_id, range, processed = self["geography_id"], self["term_id"], self["range"], self["processed"]
    
    csv = content
    
    
    # Delete the information before the start of the data
    csv.delete_if do |row|
      break if row.first == 'Week'
      true
    end
  
    # Delete the data header
    csv.shift
        
    # Delete the information after the data
    csv.keep_if do |row|
      if row.first.nil?
        false
      elsif row.first[0,2] != "20"
        false
      else
        true
      end
    end
    
    # Split up the start and end dates of the data
    csv.collect! do |row|
      val = row.first.split(" - ")
      val.push(row[1].chop)
      val
    end
    
    # Save each row as a new observation
    csv.each do |row|
      o = Observation.new
      o.term_id, o.value, o.start, o.end, o.geography_id = term_id, row[2], row[0], row[1], geography_id
      #res = o.save
    end
    
    # Update the batch to indicate it has been processed
    update_attribute(:processed, 1)
  end
end
