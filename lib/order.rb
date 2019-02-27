

class Order
  def initalize(id, products, customer, fulfillment_status: :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    raise ArgumentError unless [:pending, :paid, :processing, :shipped].include?(@fulfillment_status)
  end
end
