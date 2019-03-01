require 'csv'
require 'awesome_print'

class Order
    attr_reader :id, :products, :customer, :fulfillment_status

    def initialize(id, products, customer, fulfillment_status = :pending)
        @id = id
        @products = products
        @customer = customer
        @fulfillment_status = fulfillment_status
        
        if @fulfillment_status != :paid && @fulfillment_status != :processing && @fulfillment_status != :shipped && @fulfillment_status != :complete && @fulfillment_status != :pending
            raise ArgumentError, "No fulfillment status given"
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

    # open CSV and put into an array each line of the CSV
    def self.all
        new_order = []
        CSV.open('data/orders.csv', 'r').each do |line|
            new_order << Order.new(line[0], line[1], line[2], line[3])
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