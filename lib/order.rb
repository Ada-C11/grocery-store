class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    @fulfillment_status = :pending

    case fulfillment_status
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Please enter a valid fulfillment status."
    end
  end

  def total
    subtotal = @products.values.sum
    cost = (subtotal * 1.075).round(2)
  end

  def add_product(product_name, price)
    @products.key?(product_name) ? (raise ArgumentError, "This product is already in the collection.") : @products.store(product_name, price)
  end

  def remove_product(product_name)
    @products.key?(product_name) ? @products.delete(product_name) : (raise ArgumentError, "This product is already in the collection.")
  end
end
