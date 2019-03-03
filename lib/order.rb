class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    until [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError, "The status provided is invalid. Please enter a valid status:"
    end
  end

  def total
    order_total_with_tax = products.values.sum * 1.075
    return order_total_with_tax.floor(2)
  end

  def add_product(product_name, price)
    if products.keys.include?(product_name)
      raise ArgumentError, "the product is already exist in the system. Please enter another product or change the price of existing product"
    end
    products[product_name] = price
    return products
  end

  def self.get_order_product(order_string)
    product_hash = {}
    product_array = []

    product_array = order_string.split(/:|;/)
    i = 0
    n = (product_array.length) / 2
    n.times do
      product_hash[product_array[i]] = product_array[i + 1]
      i += 2
    end

    return product_hash
  end

  def self.all
    order_array_csv = CSV.read("../data/orders.csv")

    array_of_order_instance = []
    order_array_csv.each do |order|
      id = order[0].to_i
      products = self.get_order_product(order[1])
      customer = order[2].to_i
      fulfillment_status = order[3].to_sym

      order_instance = Order.new(id, products, customer, fulfillment_status)
      array_of_order_instance << order_instance
    end

    return array_of_order_instance
  end
end
