
require "customer"
require "colorize"

class Order

    attr_reader :id, :fulfillment_status, :products, :customer



    def initialize(id, products, customer, fulfillment_status = :pending)
       @id = id
       @products = products
       @customer = customer
        fulfillment_status_options = [:pending, :paid, :processing, :shipped, :complete]
       if fulfillment_status_options.include?(fulfillment_status) == false
            raise ArgumentError, "Please put one of the options [:pending, :paid, :processing, :shipped, :complete] "
       end
        
       @fulfillment_status = fulfillment_status

    end

    def total
        sum = @products.values.sum
        sum_with_tax = (sum + sum * 0.075).round(2)
        return sum_with_tax
    end

    def add_product(name, price)
        if @products.keys.include?(name) == true
            raise ArgumentError, 'This item is already listed!'
        else
            @products[name] = price
        end
    end


    def self.all
        orders = []
        CSV.read("data/orders.csv", headers: false).each do |line|
            products = line[1].split(";")
            product_hash = {}
            products.each do |product|
                product = product.split(":")
                product_hash[product[0]] = product[1].to_f
            end
            new_order = Order.new(line[0].to_f, product_hash, Customer.find(line[2].to_i), line[3].to_sym)
            orders.push(new_order)
        end
        return orders
    end
    
    def self.find(id)
        orders = self.all
        found_order = (orders.select{|order| id == order.id})[0]
        return found_order
    end

end