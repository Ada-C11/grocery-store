#customer 
# Create a class called Customer. Each new Customer should include the following attributes:
require_relative "order.rb"
require 'csv'

class Customer 
    attr_reader :id
    attr_accessor :email, :address 

    def initialize(id, email, address) 
     @id = id 
     @email = email
     @address = address
    end 
  
    def self.all
    customer_data = []
      CSV.open("../data/customers.csv", "r").each do |line|
      customer_id = line[0].to_i
      email = line[1]
      address_1 = line[2]
      city = line[3]
      state = line[4] 
      zip_code = line[5]
      delivery_address = { 
        street: address_1,
        city: city,
        state: state,
        zip: zip_code 
      }
      customer = Customer.new(customer_id, email, delivery_address)
      customer_data << customer
      end 
    return customer_data
    end

    def self.find(id)
    customer_match = nil 
    self.all.each do |current_customer|
        if current_customer.id == id 
        customer_match = current_customer
        break
        end 
    end 
    return customer_match
    end
end
  

