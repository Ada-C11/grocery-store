class Order
  def initialize(id, product_collection, customer_instance, fulfillment_status: pending)
    @id = id
    @product_collection = product_collection
    @customer_instance = customer_instance
    @fulfillment_status = fulfillment_status
    # fulfillment_status = [:pending, :paid, :processing, :shipping, :complete]
    # argument error raised if got given fulfillment status
  end

  def total
    #this method calculates total cost
    #sum up products
    #add .75% tax
    #round result to 2 decimal points

  end

  def add_product(product_name, price)
    #adds product info to product collection
    #if same name found, raise argument error
  end
end
