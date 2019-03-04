# Orders
require_relative "customer.rb"
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
      raise ArgumentError
      end 
    end 


    def total
    products_total = @products.map {|item, price| price}.sum
    tax = products_total * 0.075
    total = (products_total + tax).round(2)
    return total 
    end
    
    def add_product(product_name, price)
        if @products.include? (product_name)
          raise ArgumentError
         else 
          @products.store(product_name, price)
        end 
    end

    def self.all 
        order_data = []
        CSV.open("../data/orders.csv", "r").each do |line|
            id = line[0].to_i
            split_product= line[1].split(';')
            products_purchased = {}
            split_product.each do |item|
                product = item.split(':')
                products_purchased[product[0]] = product[1].to_f 
            end
            products_list = products_purchased
            customer_id = line[2].to_i
            customer = Customer.find(customer_id)
            status = line[3].to_sym
            orders = Order.new(id, products_list, customer, status)
            order_data << orders
        end
        return order_data
    end
        

        def self.find(id)
            order_match = nil 
            self.all.each do |current_order|
              if current_order.id == id 
                order_match = current_order
                break
              end 
        end 
            return order_match
    end

end