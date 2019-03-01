require "csv"

require_relative "../lib/customer.rb"

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

  # Calculate the total cost of an order
  def total
    total = @products.values.sum
    total = (total + 0.075 * (total)).round(2)
  end

  # Add a product to @products hash
  def add_product(name, price)
    if @products.keys.include?(name.downcase)
      raise ArgumentError, "A product with the same name has already " +
                           "been added to the order."
    end
    @products[name.downcase] = price.to_f.round(2)
  end

  # Remove a product from @products hash
  def remove_product(name, price)
    if !(@products.keys.include?(name.downcase))
      raise ArgumentError, "Order # #{@id} does not include the product #{name}. "
    end
    @products.delete(name.downcase)
  end

  # Helper method to parse string of products into hash
  def self.parse_products(product_string)
    products = product_string.split(";")
    products.map! { |item| item.split(":") }.each do |item|
      item[1] = item[1].to_f.round(2)
    end
    return products.to_h
  end

  # Returns an array of all Orders from CSV file
  def self.all
    all_orders = []
    CSV.open("data/orders.csv").each do |row|
      row_id = row[0].to_i
      row_products = Order.parse_products(row[1])
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

  # Returns an Order object with matching ID. If no matches are found, returns nil.
  def self.find(id)
    return (self.all).find { |order| order.id == id }
  end

  # Returns an array of all Orders objects where customer ID is equal to the number given.
  def self.find_by_customer(customer_id)
    return (self.all).select { |order| order.customer.id == customer_id }
  end

  # creates a file identical to the original csv at the specified filepath
  def self.save(filepath)
    CSV.open(filepath, "w") do |newfile|
      CSV.open("data/orders.csv").each do |row|
        newfile << row
      end
    end
  end
end
