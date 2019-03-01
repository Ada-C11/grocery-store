class Order
    attr_reader :id
    attr_accessor :products, :customer, :fulfillment_status
    
    # set statuses up as a constant
    FULLFILLMENT_STATUS = [:pending, :paid, :processing, :shipped, :complete]

    def initialize (id, products, customer, status = :pending)
        @id = id
        @products = products
        @customer = customer
        @fulfillment_status = status
    if FULLFILLMENT_STATUS.include?(status) == false
      return raise ArgumentError, "You have entered an invalid status"
    end 

    def total
        total = 0.00
        @products.each_value do |value|
          total += value
        end
        total += (total * 0.075) #7.5% tax
        return total.round(2)
    end

end