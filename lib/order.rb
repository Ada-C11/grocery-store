
class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status = :pending)
    # def initialize(id, products, customer, fulfillment_status: :pending)
    @id = id
    @products = products #hash
    @customer = customer
    @fulfillment_status = fulfillment_status
    until [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError, "Invalid fulfillment status"
    end
  end

  def total
    if products.length > 0
      sum = products.values.reduce(:+)
      tax = sum * 0.075
      total = sum + tax
      return total.round(2)
    else
      return 0
    end
  end

  def add_product(product_name, price)
    if products.include?(product_name)
      raise ArgumentError, "Product already exists"
    else
      products.merge!({product_name => price})
    end
  end
end
