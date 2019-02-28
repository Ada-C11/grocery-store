class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  attr_writer :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    if @fulfillment_status != :pending && @fulfillment_status != :paid && @fulfillment_status != :processing && @fulfillment_status != :shipped && @fulfillment_status != :complete
      raise ArgumentError, "Fulfillment status must be :pending, :paid, :processing, :shipped, :complete!"
    end
  end

  def new_order
    @order_hash = {
      id: @id,
      products: @products,
      customer: @customer,
      fulfillment_status: @fulfillment_status,
    }
    return @order_hash
  end

  def total
    total_value = 0
    @products.each do |product, value|
      total_value += value
    end
    return ("%.2f" % (total_value * 1.075)).to_f
  end

  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "A product with this name has already been added to the order!"
    end

    @products[product_name] = price
  end

  # id (number)

  # collection of products & their costs (hash)
  # # an empty hash is OK
  # # can assume there is only one of each product

  # an instance of a customer (person who placed the order)

  # fulfillment status (a symbol, :pending, :paid, :processing, :shipped, :complete)
  # # should default to :pending, if something else is given must raise an Argument Error!
end
