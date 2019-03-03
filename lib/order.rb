class Order
  attr_reader :id, :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    valid_fulfillment_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if valid_fulfillment_statuses.include? fulfillment_status
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Fufillment status must be one of #{valid_fulfillment_statuses}; received #{fulfillment_status}"
    end
  end

  def total
    sum = @products.values.sum
    # sum = @products.sum{ |key, value| value }
    return (1.075 * sum).round(2)
  end

  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError, "#{product_name} already exists in product list."
    end
    @products[product_name] = price
  end
end
