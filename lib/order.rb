require "table_flipper"

class Order 

    attr_reader :id
    attr_accessor :products, :customer, :fulfillment_status

    #
    def initialize(id, products, customer, fulfillment_status = :pending) 
        good_values = [:pending, :paid, :processing, :shipped, :complete]
        if !good_values.include?(fulfillment_status)
            raise ArgumentError, "#{fulfillment_status} is not an acceptable value for the fulfillment parameter."
        end
        @id = id
        @products = products
        @customer = customer
        @fulfillment_status = fulfillment_status
    end
    def total
        total = ((@products.values.sum) * 1.075).round(2)
    end 
    def add_product(p_name, price) 
        if products.keys.include?(p_name)
            raise ArgumentError, "#{p_name} has already been added."
        end
        @products[p_name] = price
    end

end 