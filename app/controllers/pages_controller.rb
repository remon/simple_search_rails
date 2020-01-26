class PagesController < ApplicationController
  def index
    params.delete(:price_lq_eq) if params[:price].blank?
    params.delete(:price) if params[:price_lq_eq].blank?
    @total_products = Product.search(params)

    @products = @total_products.page(params[:page]).per(12)
  end
end
