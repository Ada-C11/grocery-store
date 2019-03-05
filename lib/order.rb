require_relative "customer.rb"

class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    if [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "A valid fulfillment_status was not put into the Order"
    end
  end

  def total
    if @products.length == 0
      return 0
    else
      total = @products.values.reduce(:+)
      total *= 1.075 #Tax
      total = total.round(2)
      return total
    end
  end

  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "The product is already in the order"
    else
      @products[product_name] = price
    end
  end

  def remove_product(product_name)
    if @products.keys.include?(product_name)
      @products.reject! { |k| k == product_name }
    else
      raise ArgumentError, "The product does not exist in the order"
    end
  end

  def self.product_hash(order)
    products = order.split(";")
    products_hash = {}
    products.each do |product|
      products_hash[product.split(":")[0]] = product.split(":")[1].to_f
    end
    return products_hash
  end

  def self.all
    data = CSV.open("data/orders.csv", "r").map do |line|
      line.to_a
    end
    all_orders = []
    data.each do |order|
      all_orders << Order.new(order[0].to_i, product_hash(order[1]), Customer.find(order[2].to_i), order[3].to_sym)
    end
    return all_orders
  end

  def self.find(id)
    all_orders = Order.all
    order = all_orders.find { |order| order.id == id }
    return order
  end

  def self.find_by_customer(customer_id)
    all_orders = Order.all
    orders_by_customer = all_orders.select { |order| order.customer.id == customer_id }
    if orders_by_customer.empty?
      return nil
    else
      return orders_by_customer
    end
  end
end
