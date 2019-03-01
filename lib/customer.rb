require 'csv'
require 'awesome_print'

class Customer

  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id.to_i
    @email = email
    @address = address
  end
end

# returns a collection of Customer instances, representing all of the Customer described in the CSV file
def Customer.all
  return CSV.read("/Users/ranuseh/workspace/ada/ada_program/grocery-store/data/customers.csv").map do |customer|
    id =  customer[0]
    email = customer[1]
    address = {}
    address[:street] = customer[2]
    address[:city] = customer[3]
    address[:state] = customer[4]
    address[:zip] = customer[5]

    Customer.new(id, email, address)
  end
end

# puts Customer.all

# returns an instance of Customer where the value of the id field in the CSV matches the passed parameter
def Customer.find(id)
  customer = Customer.all.find { |customer| customer.id == id }
  return customer
end

puts Customer.find(2)
