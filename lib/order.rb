require_relative "./customer.rb"

class Order
  attr_reader :id
  attr_accessor :customer, :products, :status

  def initialize(id, products, customer, status = :pending)
    @id = id
    @products = products
    @customer = customer

    valid_statuses = %i[pending paid processing shipped complete]
    if !valid_statuses.include?(status)
      raise ArgumentError, "Only order statuses are #{valid_statuses}."
    end
    @status = status
  end

  def id
    return @id
  end

  def products
    return @products
  end

  def customer
    return @customer
  end

  def fulfillment_status
    return @status
  end

  def total
    return (@products.values.sum * 1.075).truncate(2)
  end

  def add_product(product_name, price)
    if @products.include?(product_name)
      raise ArgumentError, "#{product_name} has already been added to the list."
    end
    @products[product_name] = price
    return @products
  end
end
