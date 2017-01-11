require 'csv'

CSV.foreach('db/seed/category_data.csv') do |row|
  Category.create( label: row[0] )
end
