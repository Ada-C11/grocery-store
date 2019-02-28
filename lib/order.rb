require_relative "customer.rb"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    case fulfillment_status
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "That is an invalid fulfillment status"
    end
  end

  def total
    product_total = (@products.values.sum * 1.075).round(2)
  end

  def add_product(product_name, price)
    if @products.include?(product_name)
      raise ArgumentError, "That is not a unique product"
    else
      @products[product_name] = price
    end
  end

  def remove_product(rem_product_name)
    if @products.include?(rem_product_name)
      @products.delete(rem_product_name)
    else
      raise ArgumentError, "That product is not available to be removed"
    end
  end
end
