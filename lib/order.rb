class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    valid_statuses = %i[pending paid processing shipped complete]

    unless valid_statuses.include?(@fulfillment_status)
      raise ArgumentError, "Invalid status provided"
    end
  end

  def total
    products_sum = @products.map{|product, cost| cost}.sum
    tax =  products_sum * 0.075
    total = (products_sum + tax).round(2)
    return total
  end

  def add_product(name, price)
    if @products.include?(name)
      raise ArgumentError, "Item already added."
    end

    @products.store(name, price)
# If a product with the same name has already been added 
# to the order, an ArgumentError should be raised

  end

end