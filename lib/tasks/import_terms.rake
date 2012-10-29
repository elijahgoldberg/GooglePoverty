desc "Import terms"

task :import_terms => :environment do
  terms = File.read("terms.json")
  terms = JSON.parse(terms)
  terms = terms["children"]
  terms.cycle(1) do |f|
    t = Term.new
    t.text, t.level, t.parent = f["name"], 1, nil
    t.save
    if f["children"]
      f["children"].cycle(1) do |g|
        u = Term.new
        u.text, u.level, u.parent = g["name"], 2, t.id
        u.save
        if g["children"]
          g["children"].cycle(1) do |h|
             v = Term.new
             v.text, t.id, t.parent = h["name"], 3, u.id
             v.save
          end
        end
      end
    end
  end
end
