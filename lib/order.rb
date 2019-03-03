require_relative "../lib/customer"
require "pry"
require "awesome_print"

class Order
  attr_reader :id, :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = {}
    products.each { |product_name, price| @products[product_name] = price }
    @customer = customer
    if fulfillment_status == :pending || fulfillment_status == :paid || fulfillment_status == :processing || fulfillment_status == :shipped || fulfillment_status == :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Fulfillment_status must be pending, paid, processing, shipped or complete."
    end
  end

  def total
    sub_total = (@products.sum { |product, price| price.to_f }).to_f
    tax = (sub_total * 0.075)
    total_price = (sub_total + tax).round(2)
  end

  def add_product(product_name, price)
    raise ArgumentError, "Product already exists" if @products.has_key?(product_name)
    @products[product_name] = price
  end

  # Optional in Wave 1:
  def remove_product(product_name)
    if !@products.has_key?(product_name)
      raise ArgumentError, "Product is not in the list!"
    else
      @products.delete_if { |name, price| name == product_name }
    end
  end

  def count
    return @products.length
  end

  def self.all # returns a collection of Order instances
    return CSV.read("data/orders.csv").map do |order_from_csv|
             order = self.new(order_from_csv[0].to_i, self.get_products_from_csv(order_from_csv[1]), Customer.find(order_from_csv[2].to_i), order_from_csv[3].to_sym)
           end
  end

  def self.get_products_from_csv(product_column) # product_column is a string. Ex: "Lobster:17.18;Annatto seed:58.38;Camomile:83.21"
    products_hash = {}
    products = product_column.split(";") # products is an array: ["Lobster:17.18", "Annatto seed:58.38", "Camomile:83.21"]
    products.each do |product| # product is a string: "Lobster:17.18"
      each_product = product.split(":") # each_product is an array: ["Lobster", "17.18"]
      products_hash[each_product[0]] = each_product[1].to_f
    end
    return products_hash
  end

  def self.find(id)
    self.all.find { |order| order.id == id }
  end

  # Optional in Wave 2: returns a list of Order instances
  def self.find_by_customer(customer_id)
    return self.all.select do |order|
             order.customer.id == customer_id
           end
  end
  # Optional Wave 3
  def self.save(file_name)
    CSV.open(file_name, "w") do |file|
      CSV.read("data/orders.csv").each do |line|
        file << line
      end
    end
  end
end
