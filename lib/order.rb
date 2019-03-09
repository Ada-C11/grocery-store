require "csv"

class Order
  attr_reader :id, :products, :customer
  attr_accessor :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    raise ArgumentError if ![:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
  end

  # collects data into an order
  def order_info
    order = { id: @id, products: @products, customer: @customer, fulfillment_status: @fulfillment_status }
    return order
  end

  # calculates order total price
  def total
    product_subtotal = @products.values.sum
    product_total = product_subtotal * 1.075
    final_total = product_total.round(2)
    return final_total
  end

  # adds a product to the order if it is not already on the order
  def add_product(product_name, price)
    raise ArgumentError if @products.keys.include?(product_name)
    @products[product_name] = price
    return @products
  end

  # removes a product if it is on the order
  def remove_product(product_name)
    raise ArgumentError if !@products.keys.include?(product_name)
    @products.delete(product_name)
    return @products
  end

  # collects all orders
  def self.all
    orders = []

    CSV.open("data/orders.csv", "r").each do |order_info|
      products_array = order_info[1].split(/[;:]/)
      products_hash = Hash[*products_array]
      products_hash.each { |product, price| products_hash[product] = price.to_f }

      new_order = Order.new(order_info[0].to_i,
                            products_hash,
                            Customer.find(order_info[2].to_i),
                            order_info[3].to_sym)
      orders << new_order
    end
    return orders
  end

  # finds specific order within collection
  def self.find(id)
    Order.all.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end
end
