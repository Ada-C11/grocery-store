require 'csv'

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    valid_statuses = %i[pending paid processing shipped complete]

    unless valid_statuses.include?(@fulfillment_status)
      raise ArgumentError, "Invalid status provided"
    end
  end

  def total
    products_sum = @products.map{|product, cost| cost}.sum
    tax =  products_sum * 0.075
    total = (products_sum + tax).round(2)
    return total
  end

  def add_product(name, price)
    if @products.include?(name)
      raise ArgumentError, "Item already added."
    end
    @products.store(name, price)
  end

  # def product_string_to_hash(string)
  #   products = {}
  #   array = string.split(';')
  #   array.each do |p|
  #     p = p.split(':')
  #     products.store(p[0], p[1].to_f)
  #   end
  #   return products
  # end

  def Order.all
    orders = []
    csv_orders = CSV.read('data/orders.csv', headers: true, return_headers: true)
    csv_orders.map do |order|

      @id = order[0].to_i
      #@products = product_string_to_hash(order[1])
      @products = {}
      array = order[1].split(';')
      array.each do |p|
        p = p.split(':')
        @products.store(p[0], p[1].to_f)
      end

      @customer = Customer.find(order[2].to_i)
      @fulfillment_status = :"#{order[3]}"
      order = Order.new(@id, @products, @customer, @fulfillment_status)
      orders << order
    end
    return orders
  end

  def Order.find(id)
    (Order.all).find {|order| order.id == id}
  end

  def Order.find_by_customer(customer_id) 
    (Order.all).find_all { |order| order.customer.id == customer_id }
  end

end

