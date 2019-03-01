class Order
  attr_reader :id
  attr_accessor :customer, :fulfillment_status, :products

  def initialize(id, products, customer, fulfillment_status = :pending)
    valid_status = [:pending, :paid, :processing, :shipped, :complete]
    if !(valid_status.include?(fulfillment_status))
      raise ArgumentError, "Invalid fulfillment_status value. Acceptable " +
                           "values include :pending, :paid, :processing," +
                           " :shipped, or :complete."
    end
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end

  def total
    total = @products.values.sum
    total = (total + 0.075 * (total)).round(2)
  end

  def add_product(name, price)
    if @products.keys.include?(name.downcase)
      raise ArgumentError, "A product with the same name has already " +
                           "been added to the order."
    end
    @products[name.downcase] = price.to_f.round(2)
  end

  def remove_product(name, price)
    if !(@products.keys.include?(name.downcase))
      raise ArgumentError, "Order # #{@id} does not include the product #{name}. "
    end
    @products.delete(name.downcase)
  end
end
