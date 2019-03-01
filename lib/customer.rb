require 'csv'
require 'awesome_print'

CUSTOMER_FILEPATH = 'data/customers.csv'

# WAVE 1
class Customer
  attr_reader :id 
  attr_accessor :email, :address

  # Constructor
  def initialize(id, email, address)
    @id = id.to_i
    @email = email
    @address = address
  end

  # WAVE 2

  def self.load(filepath)
    customers = Array.new
    CSV.open(filepath, 'r').each do |csv_row|
      id = csv_row[0]
      email = csv_row[1]
      address = {
        street: csv_row[2],
        city: csv_row[3],
        state: csv_row[4],
        zip: csv_row[5]
      }

      customer = Customer.new(id, email, address)
      customers.push(customer)
    end
    return customers
  end

  def self.all
    customers_data = Customer.load(CUSTOMER_FILEPATH)
    return customers_data
  end
  
  def self.find(id)
    found_customer = nil
    Customer.all.each do |find_customer|
      if find_customer.id == id
        found_customer = find_customer 
      end
    end
    return found_customer
  end

end # class Customer end

# customer_1 = Customer.new(3, "me@email.com", "123 Main, Seattle, WA, 98011")

# puts "All CUSTOMERS:"
# ap Customer.all
# puts "\nFIRST CUSTOMER:"
# puts Customer.all.first.email
# puts "\nLAST CUSTOMER:"
# puts Customer.all.last.email

# puts Customer.find(1)
# ap Customer.find()
