require "csv"

class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  @@fulfillment_status_array = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    if !@@fulfillment_status_array.include?(@fulfillment_status)
      raise ArgumentError, "Invalid fulfillment_status"
    end
  end

  def total
    product_sum = 0 if products.length == 0
    product_sum = @products.sum { |product, price| price }
    price_with_tax = ((product_sum + product_sum * 0.075).round(2))
    return price_with_tax
  end

  def add_product(product_name, price)
    raise ArgumentError if @products.include?(product_name)
    @products[product_name] = price
  end

  def remove_product(product)
    raise ArgumentError if !@products.include?(product)
    @products.delete(product)
  end

  def self.make_product_hash(csv_string)
    product_hash = {}
    csv_string.split(";").each do |item|
      product = item.split(":")
      product_hash[product[0]] = product[1].to_f
    end
    return product_hash
  end

  def self.all
    orders_array = []
    CSV.read("data/orders.csv").each do |row|
      product_hash = Order.make_product_hash(row[1])
      new_order = Order.new(row[0].to_i, product_hash, Customer.find(row[2].to_i), row[3].to_sym)
      orders_array << new_order
    end
    return orders_array
  end

  def self.find(id)
    orders_array = Order.all
    found_order = orders_array.find do |order|
      order.id == id
    end
    return found_order
  end

  def self.find_by_customer(customer_id)
    orders_array = Order.all
    customer_orders = orders_array.select do |order|
      order.customer.id == customer_id
    end
    return nil if customer_orders.count == 0
    return customer_orders
  end

  def self.save(new_filename)
    orders = Order.all
    CSV.open(new_filename, "w") do |line|
      orders.each do |order|
        product_array = order.products.map do |product, price|
          "#{product}:#{price}"
        end
        product_string = product_array.join(";")
        line << [order.id, product_string, order.customer.id, order.fulfillment_status]
      end
    end
  end
end
