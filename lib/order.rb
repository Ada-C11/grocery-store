require "csv"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    # @products = products.map
    # products = [["Lobster", "17.18"], ["Annatto seed", "58.38"], ["Camomile", "83.21"]]

    @products = products
    @customer = customer

    fulfillment_options = [:pending, :paid, :processing, :shipped, :complete]

    unless fulfillment_options.any? fulfillment_status
      raise ArgumentError, "You entered a bogus status for fulfillment!"
    end
    @fulfillment_status = fulfillment_status
  end

  def total
    pre_tax = 0.0
    if @products != nil
      @products.each do |name, cost|
        pre_tax += cost
      end

      pre_tax += pre_tax * 0.075
      total_cost = format("%.2f", pre_tax).to_f
    else
      total_cost = 0
    end

    return total_cost
  end

  def add_product(product_name, price)
    if @products.keys.include? product_name
      raise ArgumentError, "This item already exists!"
    else
      @products[product_name] = price
    end
  end

  def self.all
    all_orders = []
    CSV.open("/Users/angelaoh/documents/grocery-store/data/orders.csv", "r").each do |item_info|
      # @products = {}
      # products = products.split(";")
      # products = products.split(":")
      # products.each_with_index do |product, index|
      #   @products["#{product[0]}"] = product[1].to_i
      # end
      # products = ["Lobster:17.18", "Annatto seed:58.38", "Camomile:83.21"]
      # products = [["Lobster", "17.18"], ["Annatto seed", "58.38"], ["Camomile", "83.21"]]
      order_instance = Order.new(
        item_info[0].to_i,
        item_info[1],
        Customer.find(item_info[2].to_i),
        item_info[3].to_sym
      )
      order_instance.products = order_instance.products.split(";")
      # order_instance.products = order_instance.products.split(":")
      product_hash = {}
      order_instance.products.each_with_index do |product, index|
        product = product.split(":")
        product_hash["#{product[0]}"] = product[1].to_f
      end
      order_instance.products = product_hash
      all_orders << order_instance
    end
    return all_orders
  end

  def self.find(id)
    all_order_info = Order.all

    all_order_info.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end
end

# practice = Order.new(1, "dasdf", 3)
# Order.all
