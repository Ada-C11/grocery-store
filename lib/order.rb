require "pry"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    unless [:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
      raise ArgumentError, "no bogus statuses allowed"
    end
  end

  # return result with two decimal places
  def total
    total = @products.map do |product, price|
      price
    end

    return (total.sum * 1.074).round(2)
  end

  # add product
  def add_product(name, value)
    @products = {
      name: value,
    }

    return @products
  end

  # optional
  def remove_product(product_name)
    unless @products.keys?(product_name)
      raise ArgumentError, "No product with that name was found."
    end

    @products.delete(product_name)
  end
end
