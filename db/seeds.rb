# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

file = File.read(Rails.root.join("lib/data.json"))
data = JSON.parse(file)
Product.destroy_all
data.each do |item|
  #puts item.to_param
  #Product.create!(item)
  @product = Product.create!(title: item["title"], description: item["description"],
                             country: item["country"], price: item["price"])

  item["tags"].split(",").each do |tag|
    @tag = Tag.find_or_create_by(name: tag.lstrip.rstrip)
    @product.product_tags.create!(tag_id: @tag.id)
  end
end
