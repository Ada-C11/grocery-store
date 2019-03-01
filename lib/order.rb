class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    # fulfillment_status = :pending <-- this is the syntax to set a default value for a positional argument

    valid_fulfillment_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !valid_fulfillment_statuses.include?(fulfillment_status)
      raise ArgumentError, "Fulfillment status is not valid."
    end
    # A fulfillment_status, a symbol, one of :pending, :paid, :processing, :shipped, or :complete
    # If no fulfillment_status is provided, it will default to :pending
    # If a status is given that is not one of the above, an ArgumentError should be raised

  end

  def total
    # A total method which will calculate the total cost of the products by:
    # Summing up the products
    # Adding a 7.5% tax
    # Rounding the result to two decimal places

    # A collection of products and their cost will be given as a hash that looks like this:
    # { "banana" => 1.99, "cracker" => 3.00 }
    # Zero products is permitted (an empty hash)
    # You can assume that there is only one of each product

    order_total = (products.values.sum * 1.075).truncate(2)

    return order_total
  end

  def add_product(product_name, product_price)
    # An add_product method which will take in two parameters, product name and price, and add the data to the product collection
    # If a product with the same name has already been added to the products, an ArgumentError should be raised
    if products.keys.include?(product_name)
      raise ArgumentError, "This product has already been ordered."
    end

    products[product_name] = product_price
  end

  def remove_product(product_name)
    # Add a remove_product method to the Order class which will take in one parameter, a product name, and remove the product from the collection
    # If no product with that name was found, an ArgumentError should be raised
    if products.keys.include?(product_name)
      products.delete(product_name)
    else
      raise ArgumentError, "Product not found."
    end
  end
end
