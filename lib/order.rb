require_relative "customer.rb"

class Order
  attr_reader :id, :customer
  attr_accessor :products, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    if %i[pending paid processing shipped complete].any? fulfillment_status
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Provided fulfullment status must be pending, paid, processing, shipped, or complete."
    end
  end

  def total
    sum = @products.values.sum
    taxed = (sum + sum * 0.075).round(2)
  end

  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError, "That product already exists"
    else
      @products[product_name] = price
    end
  end

  def remove_product(product_name)
    if @products.key?(product_name)
      @products = @products.reject { |k, v| k == product_name }
    else
      raise ArgumentError, "That product does not exist"
    end
  end

  def self.all
    orders = []
    CSV.read("data/orders.csv").each do |order|
      id = order[0].to_i
      products = Order.product_hash(order[1])
      customer = Customer.find(order[2].to_i)
      status = order[3].to_sym
      orders << Order.new(id, products, customer, status)
    end
    return orders
  end

  def self.product_hash(product_list)
    products = {}
    split_products = product_list.split(";")
    split_products.each do |product|
      product_split = product.split(":")
      products[product_split[0]] = product_split[1].to_f
    end
    return products
  end

  def self.find(id)
    orders = Order.all
    orders.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end

  def self.find_by_customer(customer_id)
    orders = Order.all
    order_list = []
    orders.each do |order|
      if order.customer.id == customer_id
        order_list << order
      end
    end
    return order_list.empty? ? nil : order_list
  end

  def self.save(file_name)
    orders = Order.all
    CSV.open(file_name, "w") do |csv|
      orders.each do |order|
        product_hash = order.products
        products = ""
        product_hash.each do |k, v|
          products << "#{k}:#{v};"
        end
        csv << [order.id, products.chomp(";"), order.customer.id, order.fulfillment_status]
      end
    end
  end
end
