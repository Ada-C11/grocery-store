class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  @@valid_statuses = %i[pending paid processing shipped complete]

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    unless @@valid_statuses.include?(@fulfillment_status)
      raise ArgumentError, "You must provide valid fulfillment status."
    end
  end

  def total
    subtotal = @products.values.sum
    total = (subtotal * 1.075).round(2)
    return total
  end
end
