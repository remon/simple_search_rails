module Api
  class ProductsController < ApplicationController
    def index
      params.delete(:price_lq_eq) if params[:price].blank?
      params.delete(:price) if params[:price_lq_eq].blank?
      @total_products = Product.search(params)

      @products = @total_products.page(params[:page]).per(12)
      render :json => {
        total_products: @total_products.count,
        current_page: @products.current_page,
        total_pages: @products.total_pages,
        products: @products,

      }
    end
  end
end
