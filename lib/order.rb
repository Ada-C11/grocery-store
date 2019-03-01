require_relative "customer.rb"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id #number
    @customer = customer #object
    @products = products #hash, { "banana" => 1.99, "cracker" => 3.00 }
    @fulfillment_status = fulfillment_status
    required_fulfillment_status = [:pending, :paid, :processing, :shipped, :complete]
    if required_fulfillment_status.include?(@fulfillment_status)
    else
      raise ArgumentError
    end
  end

  def total
    if @products == {}
      return 0
    else
      total_cost_order = @products.values.inject do |sum, n|
        sum + n
      end
      return (total_cost_order * 1.075).round(2)
    end
  end

  def add_product(product_name, price)
    # add data to product collection
    if @products.keys.include?(product_name)
      raise ArgumentError
    else
      @products.merge!({product_name => price})
    end
  end

  def remove_product(product_name)
    if @products.include?(product_name)
      @products.delete(product_name)
    else
      raise ArgumentError
    end
    return @products
  end

  def self.all
    order_data = []
    CSV.open("data/orders.csv", "r").each do |line|
      id = line[0].to_i
      products_str = line[1]
      products_str_split = products_str.split(";")
      products = {}
      products_str_split.each do |product|
        product_str_splitx2 = product.split(":")
        key = product_str_splitx2[0]
        value = product_str_splitx2[1].to_f
        products.merge!({key => value})
      end
      customer_id = line[2].to_i
      customer = Customer.find(customer_id)
      status = line[3].to_sym
      order_object = Order.new(id, products, customer, status)
      order_data << order_object
    end
    return order_data
  end
  def self.find(order_ID)
    # returns an instance of Order where the value of the id field in the
    # CSV matches the passed parameter
    order_match = self.all.detect { |order| order.id == order_ID }
    return order_match
  end
  def self.find_by_customer(customer_id)
    order_exist_check = self.all.detect { |order| order.customer.id == customer_id }
    if order_exist_check == nil
      return nil
    else
      order_match = self.all.select { |order| order.customer.id == customer_id }
      return order_match
    end
  end
end

# product_collection = {"banana" => 1.99, "cracker" => 3.00}
# address = {:building_num => "369", :street_name => "Estornino Lane", :apt_num => "", :city => "El Cajon", :state => "CA", :zipcode => "92021"}
# customer = Customer.new(1, "cylopez@uw.edu", address)
# order = Order.new(1, product_collection, customer)
# p order.remove_product("banana")
# puts order.total
# puts order.add_product("orange", 1.0)
# p order.id
# p order.products
# p order.customer.id
# p order.fulfillment_status
# p Order.all.last

# p Order.find_by_customer(1)
