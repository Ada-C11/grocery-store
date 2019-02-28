require_relative "customer"

class Order
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    unless [:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
      raise ArgumentError, "Please don't do that."
    end
  end

  attr_reader :id, :products, :customer

  attr_accessor :fulfillment_status

  def total
    # total is 0 if there's no product
    if @products.length == 0
      total = 0
    else # Sums up products
      total = @products.values.inject { |sum, cost| sum + cost }
      # Adds a 7.5% tax
      tax = total * 7.5 / 100
      total += tax
      # Rounds the result to two decimal places
      total = "%.2f" % total
    end
    # Returns total
    return total.to_f
  end

  def add_product(product_name, product_price)
    # Raises an argument if product already exists
    if @products.keys.include?(product_name)
      raise ArgumentError
    else # add data to product collection
      @products.store(product_name, product_price)
    end
  end

  def remove_product(product_name)
    unless @products.keys.include?(product_name)
      raise ArgumentError, "Product not found!"
    else
      @products.delete(product_name)
    end
  end
end
