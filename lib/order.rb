require "csv"
require_relative "customer.rb"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  FULFILLMENT_STATUS = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    if FULFILLMENT_STATUS.include?(fulfillment_status) == false
      return raise ArgumentError, "This is not a fulfillment status."
    end
  end

  def total
    total = 0.00
    @products.each_value do |value|
      total += value
    end
    total += (total * (7.5 / 100))
    return total.round(2)
  end

  def add_product(product_name, price)
    if @products.has_key?(product_name)
      return raise ArgumentError, "This item has already been ordered."
    else
      @products[product_name] = price
    end
  end

  def remove_product(product_name)
    if !(@products.has_key?(product_name))
      return raise ArgumentError, "There is no such item to remove."
    else
      @products.delete_if { |key, value| key == product_name }
    end
  end

  def self.all
    all = CSV.open("../data/orders.csv", "r").map do |order|
      products = {}
      product_array = order[1].split(",")
      product_array[0].split(";").each do |item|
        products[item.split(":")[0]] = item.split(":")[1].to_f
      end
      customer = Customer.find(order[2].to_i)
      Order.new(order[0].to_i, products, customer, order[3].to_sym)
    end
    return all
  end

  def self.find(id)
    find = Order.all
    find.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end
end
