require "csv"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  @@valid_statuses = %i[pending paid processing shipped complete]

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    unless @@valid_statuses.include?(@fulfillment_status)
      raise ArgumentError, "You must provide valid fulfillment status."
    end
  end

  def total
    subtotal = @products.values.sum
    total = (subtotal * 1.075).round(2)
    return total
  end

  def add_product(name, price)
    if @products.has_key?(name)
      raise ArgumentError, "This product is already present."
    else
      @products[name] = price
    end
  end

  def self.all
    orders = []
    CSV.read("data/orders.csv").each do |row|
      product_list = {}
      customer_products = row[1].split(";")
      customer_products.each do |string|
        product_and_price = string.split(":")
        product_list[product_and_price[0]] = product_and_price[1].to_f
      end
      orders.push(Order.new(row[0].to_i, product_list, Customer.find(row[2].to_i), row[3].to_sym))
    end
    return orders
  end

  def self.find(id)
    self.all.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end
end
