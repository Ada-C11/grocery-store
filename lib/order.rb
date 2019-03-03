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
    @products.key?(product_name) ? @products.delete(product_name) : (raise ArgumentError, "Invalid product - does not exist in current collection.")
  end

  def self.products_to_hash(product_info)
    product_hash = {}
    product_array = product_info.split(";")
    product_array.each do |product|
      key_value = product.split(":")
      product_hash[key_value[0]] = key_value[1].to_f
    end
    return product_hash
  end

  def self.all
    orders_array = []
    CSV.open("data/orders.csv", "r").each do |order|
      id = order[0].to_i
      customer = Customer.find(order[2].to_i)
      fulfillment_status = order[3].to_sym
      products = Order.products_to_hash(order[1])

      order_instance = Order.new(id, products, customer, fulfillment_status)
      orders_array << order_instance
    end
    return orders_array
  end

  def self.find(id)
    Order.all.find do |order|
      order.id == id
    end
  end

  def self.find_by_customer(customer_id)
    customer_orders = []
    Order.all.each do |order|
      if order.customer.id == customer_id
        customer_orders << order
      end
    end
    return customer_orders.length > 0 ? customer_orders : nil
  end
end
