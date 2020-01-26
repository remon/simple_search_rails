class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag
  validates_uniqueness_of :product_id, scope: :tag_id

  after_commit :clear_cache

  private

  def clear_cache
    Rails.cache.delete("#{product.id}_tags")
  end
end
