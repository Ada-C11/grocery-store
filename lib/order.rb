require_relative "customer.rb"

class Order
  def initialize(id, products, customer, fulfillment_status = "")
    @products = products
    @customer = customer
    @id = id
    case fulfillment_status
    when ""
      @fulfillment_status = :pending
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Invalid state #{fulfillment_status}"
    end
  end

  attr_reader :id, :products, :customer, :fulfillment_status

  def total
    total_price = (@products.values.sum * 1.075).round(2)

    return total_price
  end

  def add_product(name, price)
    if !@products[name]
      @products[name] = price
    else
      raise ArgumentError, "#{name} already exists in product list"
    end
  end

  def remove_product(name)
    if @products[name]
      @products.delete(name)
    else
      raise ArgumentError, "Product #{name} was not found"
    end
  end

  def self.all
    orders_csv = CSV.read("data/orders.csv", headers: true)
    all_orders = []
    orders_csv.each do |row|
      array_of_products = row["products"].split(";")
      hash_of_products = (array_of_products.map { |string| string.split(":") }).to_h
      hash_of_products.transform_values! { |v| v.to_f }

      order = Order.new(row["id"].to_i, hash_of_products, Customer.find(row["customer_id"].to_i), row["status"].to_sym)
      all_orders << order
    end
    return all_orders
  end

  def self.find(id)
    orders = Order.all
    check = true
    orders.each do |o|
      if o.id == id
        return o
      else
        check = false
      end
    end
    if check == false
      return nil
    end
  end

  def self.save(filename)
    orders = Order.all
    CSV.open(filename, "w") do |file|
      header_row = ["id", "products", "customer", "status"]
      file << header_row
      orders.each do |o|
        products_string = o.products.map { |k, v| "#{k}:#{v}" }.join(";")
        new_line = ["#{o.id}", "#{products_string}", "#{o.customer.id}", "#{o.fulfillment_status}"]
        file << new_line
      end
    end
  end
end
