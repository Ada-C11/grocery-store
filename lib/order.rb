class Order 

    attr_reader :id
    attr_accessor :products

    def initialize(id, products, customer, fulfillment = :pending) 
        good_values = [:pending, :paid, :processing, :shipped, :complete]
        if !good_values.include?(fulfillment)
            raise ArgumentError, "#{fulfillment} is not an acceptable value for the fulfillment parameter."
        end
        @id = id
        @products = products
        @customer = customer
        @fulfillment = fulfillment
    end

end 