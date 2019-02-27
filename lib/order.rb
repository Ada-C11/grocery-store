# In addition, Order should have:

# A total method which will calculate the total cost of the order by:
# Summing up the products
# Adding a 7.5% tax
# Rounding the result to two decimal places
# An add_product method which will take in two parameters, product name and price, and add the data to the product collection
# If a product with the same name has already been added to the order, an ArgumentError should be raised

class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  attr_writer :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    unless [:pending, :paid, :processing, :complete, :shipped].include?(@fulfillment_status)
      raise ArgumentError, "Status not found"
    end
  end

  def total
    return (@products.values.sum * 1.075).round(2)
  end

  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "Product already exists in order"
    end
    @products[product_name] = price
  end
end

order = Order.new("123", {}, "customer")
puts order
