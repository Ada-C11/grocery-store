class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    @fulfillment_status = :pending

    case fulfillment_status
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Please enter a valid fulfillment status."
    end
  end

  def total
    subtotal = @products.values.sum
    cost = (subtotal * 1.075).round(2)
  end

  def add_product(product_name, price)
    @products.key?(product_name) ? (raise ArgumentError, "This product is already in the collection.") : @products.store(product_name, price)
  end

  def remove_product(product_name)
    @products.key?(product_name) ? @products.delete(product_name) : (raise ArgumentError, "This product is already in the collection.")
  end

  def self.all
    orders_array = []
    CSV.open("data/orders.csv", "r").each do |order|
      product_hash = {}
      id = order[0].to_i
      product_array = order[1].split(";")
      product_array.each do |product|
        key_value = product.split(":")
        product_hash[key_value[0]] = key_value[1].to_f
      end
      products = product_hash
      customer = Customer.find(order[2].to_i)
      fulfillment_status = order[3].to_sym
      order_instance = Order.new(id, products, customer, fulfillment_status)
      orders_array << order_instance
    end
    return orders_array
  end

  def self.find(id)
    all_customer_info = Customer.all
    return id > all_customer_info.length ? nil : all_customer_info[id - 1]
  end
end
