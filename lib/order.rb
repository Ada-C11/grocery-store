# class that creates an instance of an order
class Order

  # creates methods that will allow reading or writing of specified instance variables
  attr_reader :id, :products, :customer, :fulfillment_status
  attr_writer :fulfillment_status

  # constructor that sets up each instance of an order's id, products, customer, and fulfillment
  # status. Raises an ArgumentError if fulfillment entered is not a valid option
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    unless [:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
      raise ArgumentError, "Fulfillment status must be :pending, :paid, :processing, :shipped, :complete!"
    end
  end

  # method that returns a hash containing the id, products, customer, and fulfillment status for an order
  def new_order
    @order_hash = {
      id: @id,
      products: @products,
      customer: @customer,
      fulfillment_status: @fulfillment_status,
    }
    return @order_hash
  end

  # method that returns the total value, plus 7.5% tax of all products in an order
  def total
    return @products.sum { |product, value| ("%.2f" % (value * 1.075)).to_f }
  end

  # method that adds a product and price to the existing products hash of an order
  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "A product with this name has already been added to the order!"
    end

    @products[product_name] = price
  end
end
