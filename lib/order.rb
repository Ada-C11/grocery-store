class Order
  def initialize(id, products, customer, fulfillment_status = "")
    @products = products
    @customer = customer
    @id = id
    case fulfillment_status
    when ""
      @fulfillment_status = :pending
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Invalid state #{fulfillment_status}"
    end
  end

  attr_reader :id, :products, :customer, :fulfillment_status

  def total
    total_price = (@products.values.sum * 1.075).round(2)

    return total_price
  end

  def add_product(name, price)
    if !@products[name]
      @products[name] = price
    else
      raise ArgumentError, "#{name} already exists in product list"
    end
  end

  def remove_product(name)
    if @products[name]
      @products.delete(name)
    else
      raise ArgumentError, "Product #{name} was not found"
    end
  end

  def self.all
    orders_csv = CSV.read("data/orders.csv", headers: true)
    all_orders = []
    orders_csv.each do |row|
      order = Order.new(row[0].to_i, row[1], row[2].to_i, row[3].to_sym)
      all_orders << order
    end
    return all_orders
  end
end

orders = Order.all
