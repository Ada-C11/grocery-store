require_relative "customer.rb"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    case fulfillment_status
    when :pending,
         :paid,
         :processing,
         :shipped,
         :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Please enter a valid fulfillment status"
    end
  end


  def total
    total = ((@products.values.sum) * 1.075).round(2)
    return total
  end


  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError, 
        "That item has already been added"
    else
      @products.store(product_name, price)
    end
  end


  def remove_product(product_name)
    if @products.has_key?(product_name)
      @products.delete(product_name)
    else 
      raise ArgumentError, "Item not found" 
    end
  end


  def self.all
    orders_array = []
      CSV.read("data/orders.csv", "r").each do |info_line|
        hash = {}
        id = info_line[0].to_i
        products = info_line[1].split(";")
            products.each do |x|
              product = x.split(":")
              hash[product[0]] = product[1].to_f
            end
        products = hash
        customer = Customer.find(info_line[2].to_i)
        status = info_line[3].to_sym
        order = Order.new(id, products, customer, status)
    orders_array << order
      end
    return orders_array
  end

  def self.find(id)
    Order.all.find do |order|
      order.id == id
    end
  end
end
