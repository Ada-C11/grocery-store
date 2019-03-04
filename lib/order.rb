require 'csv'
# Order is responsible for tracking orders with prices for all orders from CSV
class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  # Creates one order record
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    fs_types = %i[pending paid processing shipped complete]
    raise ArgumentError, 'Wrong status' if fs_types.none? @fulfillment_status
  end

  # Calculates total price for one order with tax
  def total
    (@products.values.sum * 1.075).round(2)
  end

  def add_product(name, price)
    raise ArgumentError if @products.key?(name)

    @products[name] = price
  end

  # reads all of the orders from CSV into hash
  def self.all
    all_orders = CSV.read('data/orders.csv').map do |row|
      id = row[0].to_i
      products_list = get_product_list(row[1])
      customer = Customer.find(row[2].to_i)
      fulfillment_status = row[3].to_sym
      self.new(id, products_list, customer, fulfillment_status)
    end
    all_orders
  end

  # creates a hash - key value pairs from items with their prices
  def self.get_product_list(groceries)
    groceries_list = {}
    groceries.split(';').each do |groceries|
      product_array = groceries.split(':')
      groceries_list[product_array[0]] = product_array[1].to_f
    end
    groceries_list
  end
end
