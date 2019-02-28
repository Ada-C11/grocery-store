class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    # if !([:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status))
    #   raise ArgumentError, "Color options are :blue, :red, :rainbow, :purple, :gold, and :green"
    # end

    unless [:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
      raise ArgumentError, "Not valid fulfillment status"
    end 
  end

  def total
    sum = @products.values.sum
    taxed_sum = sum + (sum * 0.075)
    return taxed_sum.round(2)
  end

  def add_product(product_name, price)
    raise ArgumentError, "This product has already been added" if @products.keys.include?(product_name)
    @products[product_name] = price
  end
end
