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
    # calculate the total cost of the products incl 7.5% tax; round to two decimal places
    order_total = (products.values.sum * 1.075).truncate(2)
    return order_total
  end

  def add_product(product_name, product_price)
    # add a new product to the product collection; if a product with the same name has already been added to the products, an ArgumentError should be raised
    if products.keys.include?(product_name)
      raise ArgumentError, "This product has already been ordered."
    end

    products[product_name] = product_price
  end

  def remove_product(product_name)
    # WRITING THIS METHOD WAS OPTIONAL
    # remove a specified product from the collection; if no product with that name was found, an ArgumentError should be raised
    if products.keys.include?(product_name)
      products.delete(product_name)
    else
      raise ArgumentError, "Product not found."
    end
  end

  def self.products_helper(products_from_csv_row) # <-- convert string to hash
    # "Capers:20.66;Tarragon:36.04;Arborio rice:67.06;Bean Shoots:41.97"
    products_hash = {}
    products_array_1 = products_from_csv_row.split(";")
    # products_array_1 = ["Capers:20.66", "Tarragon:36.04", "Arborio rice:67.06", "Bean Shoots:41.97"]
    products_array_1.each do |product_and_price_string|
      products_array_2 = product_and_price_string.split(":")
      # product_and_price_stirng ["Capers", "20.66"]
      products_hash[products_array_2[0]] = products_array_2[1].to_f
    end

    return products_hash
  end

  def self.all
    orders = [] # this is an array of instances of Order

    CSV.open("data/orders.csv", "r").each do |order_row| # <-- order_row should be an array of strings
      # example: ["31","Capers:20.66;Tarragon:36.04;Arborio rice:67.06;Bean Shoots:41.97","13","processing"]
      # parameters to pass to Order.new: order id, products, cust id, fulfill status
      orders << Order.new(order_row[0].to_i, self.products_helper(order_row[1]), Customer.find(order_row[2].to_i), order_row[3].to_sym)
    end

    return orders
  end

  def self.find(id)
    self.all.each do |order|
      if order.id == id
        return order # an instance of Order where the value of the id field in the CSV matches the passed paramater
      end
    end
    return nil # <-- Exit the loop. If the id wasn't found by the if statement, return nil.
  end

  # def Order.find_by_customer(customer_id)
  #   # WRITING THIS METHOD IS OPTIONAL
  #   orders_by_this_customer = []
  #   # this_customer_id = customer_id
  #   orders_to_check = self.all
  #   orders_to_check.each do |order_instance|
  #     puts "order_instance.customer"
  #     puts order_instance.customer
  #     if order_instance.customer == customer_id
  #       orders_by_this_customer << order_instance
  #     end
  #     return orders_by_this_customer # a list [] of Order instances where the value of the customer's ID matches the passed parameter
  #   end
  # end
end

# Order.find_by_customer(25)
