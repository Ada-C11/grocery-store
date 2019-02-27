class Order
  attr_reader :id, :customer
  attr_accessor :products, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    if %i[pending paid processing shipped complete].any? fulfillment_status
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Provided fulfullment status must be pending, paid, processing, shipped, or complete."
    end
  end

  def total
    sum = @products.values.sum
    taxed = (sum + sum * 0.075).round(2)
  end

  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError, "That product already exists"
    else
      @products[product_name] = price
    end
  end
end
