class Order
  attr_reader :id

  def initialize(id, products_and_costs, customer, fulfillment_status: :pending)
    @id = id
    @products_and_costs = products_and_costs
    @customer = customer
    @fulfillment_status = fulfillment_status

    unless fulfillment_status == :pending || fulfillment_status == :paid || fulfillment_status == :processing || fulfillment_status == :shipped || fulfillment_status == :complete
      raise ArgumentError, "invalid fulfillment status"
    end
  end

  def total(products_and_costs)
    costs = products_and_costs.values
    total = (costs.sum + costs.sum * 0.075).round(2)
  end

  def add_product(product_name, price)
    if @products_and_costs.keys.include?(product_name)
      raise ArgumentError, "product already exists"
    end
    @products_and_costs[:product_name] = price
  end
end
