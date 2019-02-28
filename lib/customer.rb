require 'csv'
require 'awesome_print'

CUSTOMER_FILEPATH = '../data/customers.csv'
# WAVE 1

# Customer
# Create a class called Customer. Each new Customer should include the following attributes:

# ID, a number
# Email address, a string
# Delivery address, a hash
# ID should be readable but not writable; the other two attributes can be both read and written.

class Customer
  attr_reader :id 
  attr_accessor :email, :address

  # Constructor
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address 
  end

  # Wave 2
  def self.all
    customers = []
    CSV.open(CUSTOMER_FILEPATH, 'r').each do |customer|
      customers.push(customer)
    end
    return customers
  end

end # class Customer end

puts self.all