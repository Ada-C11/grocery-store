require 'csv'
require_relative 'customer.rb'

class Order
	attr_reader :id
	attr_accessor :products, :fulfillment_status, :customer

	def initialize(id, products, customer, fulfillment_status = :pending)
		@id = id
		@products = products
		@fulfillment_status = fulfillment_status
		@customer = customer

		statuses = [:pending, :paid, :processing, :shipped, :complete]
		if !statuses.include?(fulfillment_status)
			raise ArgumentError.new("Invalid fulfillment status.")
		end
	end

	def total
		if @products.empty?
			return 0
		end
		tax_rate = 7.5 / 100.0 
		return (@products.values.sum * (1.0 + tax_rate)).round(2)
	end

	def add_product(name, price)
		if @products.has_key?(name)
			raise ArgumentError.new("Product name already existed")
		end
		@products[name] = price
	end
	# need to write test for this
	def remove_product(name)
		@products.delete_if {|product, price|
			product.casecmp(name) == 0
		}
	end

	def self.all
		orders = []
		CSV.open("/Users/elisepham/Ada/grocery-store/data/orders.csv", 'r').each do |row|
			temp_array = row[1].split(";")
			products = Hash.new
			temp_array.each do |item|
				temp = item.split(":")
				temp.each do |element|
						products[temp[0]] = temp[1].to_f
				end
			end
			customer = Customer.find(row[2].to_i)
			order = Order.new(row[0].to_i, products, customer, row[3].to_sym)
			orders << order
		end
		return orders
	end

	def self.find(look_up_value)
		orders = Order.all
		orders.each do |order|
			if order.id == look_up_value
				return order
			end
		end
		return nil
	end

	def self.find_by_customer(customer_id)
		orders = Order.all
		result = Array.new
		orders.each do |order|
			if order.customer.id == customer_id
				result << order
			end
		end
		return result
	end
		
	def self.save(file_name, orders)
		CSV.open(file_name, "wb") do |csv|
			orders.each do |order|
				result = ""
				order.products.each_pair do |k, v|
					result += "#{k}:#{v};"
				end
        csv << ["#{order.id}","#{result.chomp(";")}","#{order.customer.id}","#{order.fulfillment_status}"]
      end
    end
	end
end

orders = Order.all
Order.save("../data/orders_wave3.csv", orders)