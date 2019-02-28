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

end