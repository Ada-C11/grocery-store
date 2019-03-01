require "csv"
require_relative "../lib/customer.rb"
require "pry"

def parse_products(product_string)
  products = product_string.split(";")
  products.map! { |item| item.split(":") }.each do |item|
    item[1] = item[1].to_f.round(2)
  end
  return products.to_h
end

class Order
  attr_reader :id
  attr_accessor :customer, :fulfillment_status, :products

  def initialize(id, products, customer, fulfillment_status = :pending)
    valid_status = [:pending, :paid, :processing, :shipped, :complete]
    if !(valid_status.include?(fulfillment_status))
      raise ArgumentError, "Invalid fulfillment_status value. Acceptable " +
                           "values include :pending, :paid, :processing," +
                           " :shipped, or :complete."
    end
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end

  def total
    total = @products.values.sum
    total = (total + 0.075 * (total)).round(2)
  end

  def add_product(name, price)
    if @products.keys.include?(name.downcase)
      raise ArgumentError, "A product with the same name has already " +
                           "been added to the order."
    end
    @products[name.downcase] = price.to_f.round(2)
  end

  def remove_product(name, price)
    if !(@products.keys.include?(name.downcase))
      raise ArgumentError, "Order # #{@id} does not include the product #{name}. "
    end
    @products.delete(name.downcase)
  end

  def self.all
    all_orders = []
    CSV.open("data/orders.csv").each do |row|
      row_id = row[0].to_i
      row_products = parse_products(row[1])
      row_customer = Customer.find(row[2].to_i)
      row_status = row[3] ? row[3].to_sym : nil
      if row_status
        all_orders << Order.new(row_id, row_products, row_customer, row_status)
      else
        all_orders << Order.new(row_id, row_products, row_customer)
      end
    end
    return all_orders
  end
  def self.find(id)
    return (self.all).find { |order| order.id == id }
  end
end
