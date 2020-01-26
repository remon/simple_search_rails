json.products @products do |p|
  json.title p.title
  json.price p.price
  json.description p.description
  json.tags p.tags.pluck(:name)
end

json.total_products @total_products.count
json.current_page @products.current_page
json.total_pages @products.total_pages
