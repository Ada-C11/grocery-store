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
        # accounting for tax
        total += (total * 0.075) 
        return total.round(2)
    end

    def add_product(item, price)
        if @products.has_key?(item)
          return raise ArgumentError, "You are trying to enter an item that already exists."
        else
          new_item = {item => price}
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
    


end