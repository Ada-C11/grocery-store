class Order
  attr_reader :id, :products, :customer, :fulfillment_status

  @@tax_rate = 0.075

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    unless fulfillment_status == :pending ||
           fulfillment_status == :paid ||
           fulfillment_status == :processing ||
           fulfillment_status == :shipped ||
           fulfillment_status == :complete
      raise ArgumentError, "invalid fulfillment status"
    end
  end

  def self.products_hash(products_string)
    items_with_prices = products_string.split(";")

    products_hash = {}

    items_with_prices.each do |item_with_price|
      array = item_with_price.split(":")

      item = array[0]
      price = array[1].to_f

      products_hash[item] = price
    end

    return products_hash
  end

  def self.all
    orders_array = []

    CSV.open("data/orders.csv", "r").each do |line|
      id = line[0].to_i
      products_string = line[1]
      products = products_hash(products_string)
      customer_id = line[2].to_i
      customer = Customer.find(customer_id)
      fulfillment_status = line[3].to_sym
      orders_array << Order.new(id, products, customer, fulfillment_status)
    end

    return orders_array
  end

  def self.find(id)
    Order.all.each { |order| return order if order.id == id }
    return nil
  end

  def tax_rate
    @@tax_rate
  end

  def costs
    costs = products.values
  end

  def total
    total = (costs.sum + costs.sum * tax_rate).round(2)
  end

  def add_product(product_name, price)
    if products.keys.include?(product_name)
      raise ArgumentError, "product already exists"
    end

    products[product_name] = price
  end

  def remove_product(product_name)
    if products.keys.include?(product_name)
      products.delete(product_name)
    else
      raise ArgumentError, "you cannot remove a product that" \
            "does not exist"
    end
  end
end
