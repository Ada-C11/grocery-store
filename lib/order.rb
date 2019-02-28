class Order
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status)
    @ID = id
    @products = products #hash
    @customer = customer
    @fulfillment_status = fulfillment_status
  end

  def id # I have to have this reader because the helper doesn't work
    return @ID
  end

  def fulfillment
    case fulfillment_status
    when :pending
    when :paid
    when :processing
    when :shipped
    when :complete
    end
  end

  #   def total
  #     # sum up products
  #     # Add 7.5% tax
  #     # round totals to two decimal places
  #   end

  #   def add_product(product_name, price)
  #     # add data to product collection
  #     #if product_name already exist raise an ArgumentError
  #   end
end
