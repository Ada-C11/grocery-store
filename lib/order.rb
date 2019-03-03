require 'csv'
require 'awesome_print'
require_relative 'customer'

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    valid_statuses = %i[pending paid processing shipped complete]
    if valid_statuses.include?(fulfillment_status)
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Invalid status"
    end
  end

  def total
    total = (@products.values.sum * 1.075).round(2)
    return total
  end

  def add_product(name, price)
      @products.key?(name) ? (raise ArgumentError, "There is a duplicate item") : @products.store(name, price)
  end

  # Optional
  def remove_product(name)
    @products.delete_if {|k, v| k >= name}
  end

  def self.all
    orders = []
    CSV.read('data/orders.csv').each do |line|
      products = line[1].split(";")
      product_hash = {}
      products.each do |item|
        product = item.split(":")
        product_hash[product[0]] = product[1].to_f
      end
      order = Order.new(line[0].to_i, product_hash, Customer.find(line[2].to_i), line[3].to_sym)
      orders << order
    end
    return orders
  end

  def self.find(id)
    orders = self.all
    matching_orders = orders.find do |order|
      order.id == id
    end
    return matching_orders
  end

  def self.find_by_customer(customer_id)
    orders = self.all
    matching_customer = Customer.find(customer_id)
    matching_orders = orders.select { |order| matching_customer.id == order.customer.id }
    return nil if customer_orders.count == 0
    return matching_orders
  end

  def self.save(filename)
    orders = self.all
    CSV.open(filename, "w") do |file|
      orders.each do |order|
        each_order = [order.id.to_s]
        prod_strings_arr = []
        order.products.each do |prod_name, prod_price|
          prod_strings_arr << "#{prod_name}:#{prod_price}"
        end
        each_order << prod_strings_arr.join(";") << order.customer.id.to_s << order.fulfillment_status.to_s
        file << each_order
      end
    end
  end
end