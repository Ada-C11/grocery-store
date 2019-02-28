# WAVE 2

# Order
# Create a class called Order. Each new Order should include the following attributes:

# ID, a number (read-only)
# A collection of products and their cost. This data will be given as a hash that looks like this:
# { "banana" => 1.99, "cracker" => 3.00 }
# Zero products is permitted (an empty hash)
# You can assume that there is only one of each product
# An instance of Customer, the person who placed this order
# A fulfillment_status, a symbol, one of :pending, :paid, :processing, :shipped, or :complete
# If no fulfillment_status is provided, it will default to :pending
# If a status is given that is not one of the above, an ArgumentError should be raised
# In addition, Order should have:

# A total method which will calculate the total cost of the order by:
# Summing up the products
# Adding a 7.5% tax
# Rounding the result to two decimal places
# An add_product method which will take in two parameters, product name and price, and add the data to the product collection
# If a product with the same name has already been added to the order, an ArgumentError should be raised
# Optional:
# Make sure to write tests for any optionals you implement!

# Add a remove_product method to the Order class which will take in one parameter, a product name, and remove the product from the collection
# If no product with that name was found, an ArgumentError should be raised

class Order
  
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  # Constructor
  def initialize(id, products, customer, fulfillment_status = :pending)
    
    # raises error if the below fulfillment_statuses are not provided as an argument
    if (fulfillment_status != :pending) && (fulfillment_status != :paid) && (fulfillment_status != :processing) && (fulfillment_status != :shipped) && (fulfillment_status != :complete)
      raise ArgumentError.new("This is not a real status")
    end
    # uses :pending as default fulfillment status if no status is provided
    if fulfillment_status == nil
      fulfillment_status = :pending
    end

    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end

  # A total method which will calculate the total cost of the order by:
  #   Summing up the products
  #   Adding a 7.5% tax
  #   Rounding the result to two decimal places
  def total
    sum = 0
    taxed_sum = 0
    @products.each_value do |price|
      sum += price
      taxed_sum = sum + (sum * 0.075)
    end
    return taxed_sum.round(2)
  end

  # An add_product method which will take in two parameters, product name and price, and add the data to the product collection
  #   If a product with the same name has already been added to the order, an ArgumentError should be raised

  def add_product(name, price)
    if @products.include?(name)
      raise ArgumentError.new("A product with this name already exists")
    end

    @products[name] = price

  end
end # class Order end