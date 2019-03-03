require "csv"
require_relative "../lib/customer.rb"

class Order
  include Comparable

  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  # set statuses up as a constant
  FULLFILLMENT_STATUS = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id, products, customer, status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = status
    if FULLFILLMENT_STATUS.include?(status) == false
      return raise ArgumentError, "You have entered an invalid status"
    end

    def add_product(item, price)
      if @products.has_key?(item)
        return raise ArgumentError, "You are trying to enter an item that already exists."
      else
        new_item = { item => price }
        @products = @products.merge(new_item)
      end
    end

    def remove_product(item)
      if @products.has_key?(item) == false
        return raise ArgumentError, "You are trying to remove an item that doesn't exist."
      else
        @products = @products.delete_if { |key, value| key == item }
      end
    end

    def total
      total = 0.00
      @products.each_value do |value|
        total += value
      end
      # accounting for tax
      total += (total * 0.075)
      return total.round(2)
    end

    def self.all
      @orders = []
      CSV.open("./data/orders.csv").each do |row|
        order_id = row[0].to_i
          order_products = {}
          row_products = row[1]
          row_products = row_products.split(';')
          row_products.each do |row_product|
          row_product = row_product.split(':')
          product = { row_product[0] => row_product[1].to_f }
          order_products = order_products.merge(product)
      end

      # here replace CSV customer id w/customer object
      customer_id = row[2].to_i
      customer = Customer.find(customer_id)

      order_status = row[3].to_s
      final_status = ""
      FULLFILLMENT_STATUS.each do |status|
        if order_status.to_sym == status
          final_status = status
        end
      end
      order = Order.new(order_id, order_products, customer, final_status)
      @orders << order
    end
    return @orders
  end
end
