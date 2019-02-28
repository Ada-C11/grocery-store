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

  # collects data into an order
  def order_info
    order = { id: @id, products: @products, customer: @customer, fulfillment_status: @fulfillment_status }
    return order
  end

  # calculates order total price
  def total
    product_subtotal = @products.values.sum
    product_total = product_subtotal * 1.075
    final_total = product_total.round(2)
    return final_total
  end

  # adds a product to the order if it is not already on the order
  def add_product(product_name, price)
    raise ArgumentError if @products.keys.include?(product_name)
    @products[product_name] = price
    return @products
  end

  # removes a product if it is on the order
  def remove_product(product_name)
    raise ArgumentError if !@products.keys.include?(product_name)
    @products.delete(product_name)
    return @products
  end
end
