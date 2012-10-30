desc "Import terms"

task :import_terms => :environment do
  terms = File.read("terms.json")
  terms = JSON.parse(terms)
  terms = terms["children"]
  terms.cycle(1) do |f|
    t = Term.new
    t.text, t.level, t.parent, t.id = f["name"], 1, nil, f["id"]
    t.save unless Term.exists?(:id => f["id"])
    if f["children"]
      f["children"].cycle(1) do |g|
        u = Term.new
        u.text, u.level, u.parent, u.id = g["name"], 2, t.id, g["id"]
        u.save unless Term.exists?(:id => g["id"])
        if g["children"]
          g["children"].cycle(1) do |h|
             v = Term.new
             v.text, v.id, v.parent, v.id = h["name"], 3, u.id, h["id"]
             v.save unless Term.exists?(:id => h["id"])
          end
        end
      end
    end
  end
end
