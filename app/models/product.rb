class Product < ApplicationRecord
  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags
  include PgSearch::Model
  pg_search_scope :full_text, using: {tsearch: {prefix: true, :any_word => true}, trigram: {threshold: 0.3}}, against: {
                                title: "A", description: "B",
                              }, associated_against: {
                                tags: [:name],
                              }

  def cached_tags
    Rails.cache.fetch("#{id}_tags") {
      tags.to_a
    }
  end

  def self.search(params)
    products = Product.full_text(params[:term]) if params[:term].present?
    products = Product.all if products.nil?
    products = products.where(country: params[:country]) if params[:country].present?
    products = products.where("price > ?", params[:price].to_f) if params[:price_lq_eq] == "gt"
    products = products.where("price < ?", params[:price].to_f) if params[:price_lq_eq] == "lt"
    products = products.where("price = ?", params[:price].to_f) if params[:price_lq_eq] == "eq"
    products = products.reorder(price: :asc) if params[:sort_by] == "lowest"
    products = products.reorder(price: :desc) if params[:sort_by] == "highest"
    products = products.reorder(id: :desc) if params[:sort_by] == "newest"
    products = products.reorder(id: :asc) if params[:sort_by] == "oldest"

    products
  end
end
