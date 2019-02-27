require "customer"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    fulfillment_options = [:pending, :paid, :processing, :shipped, :complete]
    unless fulfillment_options.include? fulfillment_status
      raise ArgumentError, "You entered a bogus status for fulfillment!"
    end
    @fulfillment_status = fulfillment_status
  end

  def total
    pre_tax = 0.0
    if @products != nil
      @products.each do |name, cost|
        pre_tax += cost
      end

      pre_tax += pre_tax * 0.75
      total_cost = format("%.2f", pre_tax)
    else
      total_cost = format("%.2f", pre_tax)
    end

    return total_cost
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
