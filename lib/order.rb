class Order
  attr_reader :id, :products, :customer
  attr_accessor :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    raise ArgumentError if @fulfillment_status != :pending && @fulfillment_status != :paid &&
                           @fulfillment_status != :processing && @fulfillment_status != :shipped &&
                           @fulfillment_status != :complete
  end

  def order_info
    order = { id: @id, products: @products, customer: @customer, fulfillment_status: @fulfillment_status }
    return order
  end

  def total
    product_subtotal = @products.values.sum
    product_total = product_subtotal * 1.075
    final_total = product_total.round(2)
    return final_total
  end

  def add_product(product_name, price)
    raise ArgumentError if @products.keys.include?(product_name)
    @products[product_name] = price
    return @products
  end
end
