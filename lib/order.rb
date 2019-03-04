require "csv"
require_relative "./customer.rb"

class Order
  attr_reader :id
  attr_accessor :customer, :products, :status

  def initialize(id, products, customer, status = :pending)
    @id = id
    @products = products
    @customer = customer

    valid_statuses = %i[pending paid processing shipped complete]
    if !valid_statuses.include?(status)
      raise ArgumentError, "Only order statuses are #{valid_statuses}."
    end
    @status = status
  end

  def id
    return @id
  end

  def products
    return @products
  end

  def customer
    return @customer
  end

  def fulfillment_status
    return @status
  end

  def total
    return (@products.values.sum * 1.075).truncate(2)
  end

  def add_product(product_name, price)
    if @products.include?(product_name)
      raise ArgumentError, "#{product_name} has already been added to the list."
    end
    @products[product_name] = price
    return @products
  end

  def self.all
    orders = []
    CSV.open("data/orders.csv") do |file|
      file.each do |row|
        customer = Customer.find(row[2].to_i)
        items_string = row[1]
        items_array = items_string.split(";")
        products = {}
        items_array.each do |item|
          product_array = item.split(":")
          products[product_array[0]] = product_array[1].to_f
        end
        order = Order.new(row[0].to_i, products, customer, row[3].to_sym)
        orders << order
      end
    end
    return orders
  end

  def self.find(id)
    orders = self.all
    orders.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end

  def self.save(filename)
    orders = self.all
    CSV.open(filename, "w") do |file|
      orders.each do |order|
        row = []
        row << order.id
        product_string = ""
        i = 1
        order.products.keys.each do |product|
          if order.products.keys.length == i
            product_string << "#{product}:" + "#{order.products[product]}"
          else # Avoids adding semicolon to last item
            product_string << "#{product}:" + "#{order.products[product]};"
            i += 1
          end
        end
        row << product_string
        row << order.customer.id
        row << order.fulfillment_status.to_s
        file << row
      end
    end
  end
end
