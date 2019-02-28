require_relative "customer.rb"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(new_id, new_products, new_customer, new_fulfillment_status = :pending)
    @id = new_id
    @products = {}
    @customer = new_customer

    case new_fulfillment_status
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = new_fulfillment_status
    else
      raise ArgumentError, "Not a valid status."
    end
  end

  def total

    #   def add_customer
    #     Customer.new(id, email, address)
    #   end
  end
end

# def calculate_price(extra_shots: 0, is_cold: false) #don't need type and size because an instance of coffee already has a type and size
#     case @type
#     when :drip
#       price = 1.5
#     when :latte
#       price = 3.7
#     when :cappuccino
#       price = 3.2
#     else
#       puts "Invalid coffee type: #{type}"
#       return
#     end
# test = Order.new(4, 4, 6, :sandwich)
