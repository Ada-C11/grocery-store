class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    fs_types = %i[pending paid processing shipped complete]
    raise ArgumentError, 'Wrong status' if fs_types.exclude? @fulfillment_status
  end
end
