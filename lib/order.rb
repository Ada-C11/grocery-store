require "csv"

class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    until [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError, "Invalid fulfillment status"
    end
  end

  def total
    if products.length > 0
      sum = products.values.reduce(:+)
      tax = sum * 0.075
      total = sum + tax
      return total.round(2)
    else
      return 0
    end
  end

  def add_product(product_name, price)
    if products.include?(product_name)
      raise ArgumentError, "Product already exists"
    else
      products.merge!({product_name => price})
    end
  end

  def self.all
    @orders = []
    CSV.open("data/orders.csv", "r").each do |line|
      order_id = line[0]
      products_string = line[1]
      @products = products_split(products_string)
      customer = line[2]
      cus = Customer.find(customer)
      status = line[3]
      st = status.to_sym

      @orders << Order.new(order_id.to_i, @products, cus, st)
    end

    return @orders
  end

  def self.products_split(products)
    products_hash = {}
    array_products = products.split(";")
    array_products.each do |product|
      product_unit = product.split(":")
      hash = {product_unit[0] => (product_unit[1]).to_f}
      products_hash.merge! hash
    end
    return products_hash
  end

  def self.find(id)
    orders = Order.all
    orders.find do |order|
      if order.id == id.to_i
        return order
      end
    end
  end
end
