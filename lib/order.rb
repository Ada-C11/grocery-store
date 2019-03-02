require_relative "../lib/customer"
require "pry"

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
      raise ArgumentError, "Fulfillment_status must be pending, paid, processing, shipped or completed."
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

  def count
    return @products.length
  end

  def self.all
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
end

# id = 1337
# fulfillment_status = :shipped
customer = Customer.new(123, "a@a.co", { street: "123 Main",
                                         city: "Seattle",
                                         state: "WA",
                                         zip: "98101" })
# order = Order.new(id, { "orange" => 5.5 }, customer, fulfillment_status)
# p order.products
# order.add_product("banana", 5.5)
# puts "products are #{order.products}"
# p Order.get_products_from_csv("Lobster:17.18;Annatto seed:58.38;Camomile:83.21;banana:3.4")
# p Order.all

products = { "banana" => 1.99, "cracker" => 3.00 }
order = Order.new(1337, products, customer)
p order.total
