class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    unless fulfillment_status == :pending || fulfillment_status == :paid || fulfillment_status == :processing || fulfillment_status == :shipped || fulfillment_status == :complete
      raise ArgumentError, "invalid fulfillment status"
    end
  end

  def self.all
    orders_array = []
    CSV.open("data/orders.csv", "r").each do |line|
      pairs = line[1].split(";")
      hash = {}
      pairs.each do |i|
        pair = i.split(":")
        hash[pair[0]] = pair[1].to_f
      end
      orders_array << Order.new(line[0].to_i, hash, Customer.find(line[2].to_i), line[3].to_sym)
    end

    return orders_array
  end

  def total
    costs = @products.values
    total = (costs.sum + costs.sum * 0.075).round(2)
  end

  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "product already exists"
    end
    @products[product_name] = price
  end

  def remove_product(product_name)
    if @products.keys.include?(product_name)
      @products.delete(product_name)
    else
      raise ArgumentError, "you cannot remove a product that does not exist"
    end
  end
end
