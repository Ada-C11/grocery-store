require_relative "customer"
require "Rake"
require "awesome_print"

class Order
  attr_reader :id
  attr_accessor :products, :fulfillment_status, :customer, :products

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @fulfillment_status = fulfillment_status
    @customer = customer
    @products = products

    unless [:pending, :paid, :complete, :processing, :shipped].include?(fulfillment_status)
      raise ArgumentError, "This is an invalid status"
    end
  end

  def total
    pre_tax = 0
    @products.each do |key, value|
      pre_tax += value
    end
    total = (pre_tax * 0.075) + pre_tax
    return total.round(2)
  end

  def add_product(name, price)
    if @products.has_key? name
      raise ArgumentError, "Cannot duplicate extant product"
    else
      @products[name] = price
    end
    return @products
  end

  # optional remove a product from a hash
  # def remove_product name
  #   if @products.has_key?(name)
  #     @products.delete(name)
  #   else
  #     raise ArgumentError, "Item does not exist"
  #   end
  #   return @products
  # end

  def self.hashify(string)
    arr_sep = ";"
    key_sep = ":"
  
    new_array = string.split(arr_sep)
    hash = {}
    
    new_array.each do |elem|
        key_value = elem.split(key_sep)
        hash[key_value[0]] = key_value[1].to_f
    end
    return hash
  end
  

  def self.all
    all_orders = []
    CSV.open("data/orders.csv", "r").each do |line|
      id = line[0].to_i
      products = Order.hashify(line[1])
      customer_id = Customer.find(line[2].to_i)
      fulfillment_status = line[3].to_sym
      instance_of_order = Order.new(id, products, customer_id, fulfillment_status)
      all_orders << instance_of_order
    end
    return all_orders
  end

  def self.find(search_id)
    Order.all.find do |product_order|
      product_order.id == search_id
  end
end

  def self.find_by_customer_id(cust_id)
    customer_prod_hx = []
    Order.all.each do |their_purchase|
      if their_purchase.customer.id == cust_id
        customer_prod_hx << their_purchase
      end
    end
    return customer_prod_hx
  end

end

check = Order.find_by_customer_id(25)
ap check
