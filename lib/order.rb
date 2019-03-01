class Order
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status: :pending)
    valid_status = [:pending, :paid, :processing, :shipped, :complete]
    if !(valid_status.include?(fulfillment_status))
      raise ArgumentError, "Invalid fulfillment_status value. Acceptable " +
                           "values include :pending, :paid, :processing," +
                           " :shipped, or :complete."
    else
      @id = id
      @products = products
      @customer = customer
      @fulfillment = fulfillment_status
    end
  end

  def total
    total = @products.values.sum
    total = (total + 0.075 * (total)).round(2)
  end

  def add_product(name, price)
    if products.keys.include?(name.downcase)
      raise ArgumentError, "A product with the same name has already " +
                           "been added to the order."
    else
      @products[name] = price.to_f.round(2)
    end
  end
end
