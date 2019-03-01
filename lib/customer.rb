require 'csv'
require 'awesome_print'

class Customer
  attr_accessor :email, :address
  attr_reader :id

  def initialize(id, email, address)
    @id = id
    @address = address
    @email = email
  end

  def self.all
    customers = []
    CSV.open("/Users/elisepham/Ada/grocery-store/data/customers.csv", 'r').each do |row|
      address = {
        :street => row[2],
        :city => row[3], 
        :state => row[4], 
        :zip => row[5]
      }
      customer = Customer.new(row[0].to_i, row[1], address)
      customers << customer 
    end
    return customers
  end

  def self.find(look_up_value)
    customers = Customer.all
    return customers.each do |customer|
      if customer.id == look_up_value
          return customer
      end
    end
    return nil
  end

  def self.save(file_name, customers)
    CSV.open(file_name, "wb") do |csv|
      customers.each do |customer|
        csv << ["#{customer.id}","#{customer.email}","#{customer.address[:street]}",
        "#{customer.address[:city]}","#{customer.address[:state]}","#{customer.address[:zip]}"]
      end
    end
  end
end

customers = Customer.all
Customer.save("../data/customers_wave3.csv", customers)