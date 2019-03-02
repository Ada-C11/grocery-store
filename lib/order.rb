require "csv"
require_relative "customer"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    unless [:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
      raise ArgumentError, "Not valid fulfillment status"
    end
  end

  def total
    sum = @products.values.sum
    taxed_sum = sum + (sum * 0.075)
    return taxed_sum.round(2)
  end

  def add_product(product_name, price)
    raise ArgumentError, "This product has already been added" if @products.keys.include?(product_name)
    @products[product_name] = price
  end

  def remove_product(product_name)
    raise ArgumentError, "No product with that name was found" if !@products.keys.include?(product_name)
    @products.delete(product_name)
  end

  def self.all
    all_orders = []
    CSV.read("/Users/karlaguadron/Documents/ada/03_week/grocery-store/data/orders.csv").each do |order|
      product_array = order[1].split(";")
      new_array =
        product_array.map do |product|
          entry = product.split(":")
          entry[1] = entry[1].to_f
          entry
        end
      product_hash = Hash[new_array]
      all_orders << Order.new(order[0].to_i, product_hash, Customer.find(order[2].to_i), order[3].to_sym)
    end
    return all_orders
  end

  def self.find(id)
    Order.all.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end

  def self.find_by_customer(customer_id)
    all_orders = Order.all
    indiv_orders = all_orders.select do |order|
      order.customer.id ==  customer_id
    end
    return nil if indiv_orders.count == 0
    return indiv_orders
  end

  def self.save(file_name)
    order_list = Order.all
    CSV.open(file_name, "w") do |line|
      order_list.each do |order|
        indiv_order = [order.id.to_s]
        prod_string_array = []
        order.products.each do |prod_name, price|
          prod_string_array << "#{prod_name}:#{price}"
        end
        indiv_order << prod_string_array.join(";")
        indiv_order << order.customer.id.to_s
        indiv_order << order.fulfillment_status.to_s
        line << indiv_order
      end
    end
  end    
end

Order.save("hi.csv")
