class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    unless [:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
      raise ArgumentError, "No bogus statuses allowed!"
    end
  end

  # return result with two decimal places
  def total
    total = @products.map do |product, price|
      price
    end

    return (total.sum * 1.074).round(2)
  end

  # add product
  def add_product(name, value)
    if @products.has_key?(name)
      raise ArgumentError, "This product is already added."
    end

    @products[name] = value

    return @products
  end

  # optional
  def remove_product(product_name)
    unless @products.has_key?(product_name)
      raise ArgumentError, "No product with that name was found."
    end

    @products.delete(product_name)

    return @products
  end

  def self.all
    order_array = []

    CSV.read("data/orders.csv").each do |row|
      id = row[0].to_i

      products = {}
      # iterate to split by ; and :
      # store most nested array into products hash
      row[1].split(";").each do |item|
        each_product = item.split(":")
        products[each_product[0]] = each_product[1].to_f
      end

      customer = Customer.find(row[2].to_i)
      fulfillment_status = row[3].to_sym

      order = Order.new(id, products, customer, fulfillment_status)
      order_array << order
    end

    return order_array
  end

  def self.find(order_id)
    Order.all.each do |order|
      if order.id == order_id
        return customer
      end
    end

    return nil
  end
end
