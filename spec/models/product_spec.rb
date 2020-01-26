require "rails_helper"

RSpec.describe Product, type: :model do
  before(:all) do
    Product.destroy_all
    file = File.read(Rails.root.join("lib/dummy_data.json"))
    data = JSON.parse(file)
    data.each do |item|
      @product = Product.create!(title: item["title"], description: item["description"],
                                 country: item["country"], price: item["price"])

      item["tags"].split(",").each do |tag|
        @tag = Tag.find_or_create_by(name: tag.lstrip.rstrip)
        @product.product_tags.create!(tag_id: @tag.id)
      end
    end
  end
  context "simple search" do
    it "should return number of products" do
      @products = Product.all
      expect(@products.count).to eq(5)
    end
    it "should return all products (no term provided)" do
      @params = {sort_by: ""}
      @products = Product.search(@params)
      expect(@products.count).to eq(5)
    end
  end
  context "advanced search (search by country)" do
    it "should return all products by country (United States)" do
      @params = {sort_by: "", country: "United States"}
      @products = Product.search(@params)
      expect(@products.count).to eq(1)
    end
  end
  context "advanced search(term and default sort)" do
    before(:each) do
      @params = {sort_by: "", term: "bath"}
      @products = Product.search(@params)
    end
    it "should return search results" do
      expect(@products.count).to eq(3)
    end

    it "should return the first sorted by title " do
      expect(@products.first.title).to eq("Passionfruit and Guava Bath Bomb, Bath Fizzy")
      expect(@products.last.tags.pluck(:name)).to eq(["halter", "two piece", "bath"])
    end
    it "shouldnot return the product with term in description only as first" do
      expect(@products.first.title).not_to eq("Alien Suede Dad Hat")
    end
    it "should return the product with country in search" do
      @params = {sort_by: "", term: "bath", country: "China"}
      @products = Product.search(@params)
      expect(@products.count).to eq(1)
      expect(@products.first.title).to eq("Alien Suede Dad Hat")
    end
    it "should return no products with country France" do
      @params = {sort_by: "", term: "bath", country: "France"}
      @products = Product.search(@params)
      expect(@products.count).to eq(0)
    end
  end

  context "advanced sort (sort by price(highest first))" do
    before(:each) do
      @params = {sort_by: "highest", term: "bath"}
      @products = Product.search(@params)
    end

    it "should return products sorted by highest price" do
      expect(@products.first.price).to eq(18.54)
    end
    it "should return products sorted by highest price(last product)" do
      expect(@products.last.price).to eq(4.59)
    end
  end
  context "advanced sort (sort by price(lowest first))" do
    before(:each) do
      @params = {sort_by: "lowest", term: "bath"}
      @products = Product.search(@params)
    end

    it "should return products sorted by lowest price" do
      #return lowest price
      expect(@products.first.price).to eq(4.59)
    end
    it "should return products sorted by lowest price(last product)" do
      expect(@products.last.price).to eq(18.54)
    end
    it "should return products greater than 5" do
      @params = {sort_by: "lowest", term: "bath", price_lq_eq: "gt", price: 5}
      @products = Product.search(@params)
      expect(@products.count).to eq(2)
    end
    it "should return products less than 5" do
      @params = {sort_by: "lowest", term: "bath", price_lq_eq: "lt", price: 5}
      @products = Product.search(@params)
      expect(@products.count).to eq(1)
    end
    it "should return products less than 4" do
      @params = {sort_by: "lowest", term: "bath", price_lq_eq: "lt", price: 4}
      @products = Product.search(@params)
      expect(@products.count).to eq(0)
    end
  end
end
