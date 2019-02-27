
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

end


test = Order.new(12, {}, "customer", :shipped)

puts test.fulfillment_status
