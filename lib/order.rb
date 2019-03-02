require 'csv'
require 'awesome_print'
require_relative 'customer'

class Order
    attr_reader :id
    attr_accessor :products, :customer, :fulfillment_status

    def initialize(id, products, customer, fulfillment_status = :pending)
        @id = id
        @products = products
        @customer = customer
        @fulfillment_status = fulfillment_status

        status = [:paid, :processing, :shippped, :complete, :pending]
        if !status.include?(fulfillment_status)
            raise ArgumentError, "No valid fulfillment status given."
        end
    end

    def total
        total_cost = 0
        if @products != []
            @products.each_value do |cost|
             total_cost += cost
            end
            total_cost_tax = (total_cost * 1.075).round(2)
            return total_cost_tax
        end
        return total_cost
    end

    def add_product(product_name, price)
        if @products.include?(product_name)
            raise ArgumentError, "Item is already in inventory."
        end
        @products[product_name] = [price]
    end

    # open CSV and put into an array each line of the CSV; creating each parameter of Order.new and putting products into hash
    def self.all
        new_order = []
        CSV.open('data/orders.csv', 'r').each do |line|
            product_hash = {}
            id = line[0].to_i
            products = line[1].split(';')
            products.each do |each_item|
                product = each_item.split(':')
                product_hash[product[0]] = product[1].to_f
            end
            products = product_hash
            customer = Customer.find(line[2].to_i)
            fulfillment_status = line[3].to_sym
            orders = Order.new(id, products, customer, fulfillment_status)
            new_order << orders
        end
        return new_order
    end

    # pull all the order information, look for ID, match?
    def self.find(id)
        Order.all.each do |order_number|
            if order_number.id == id
                return order_number
            end 
        end
        return nil
    end
end