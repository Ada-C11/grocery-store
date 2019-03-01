require 'csv'
require 'awesome_print'

class Customer
  attr_accessor(:email, :address, :id)
  # Contains methods pertaining to customers
  def initialize(id, email, address)
    @address = address
    @email = email
    @id = id
  end

  def self.all
    customers = []
    CSV.foreach('data/customers.csv') do |row|
      new_customer = Customer.new(row[0].to_i, row[1], %i[street city state zip].zip(row.slice(2..5)).to_h)
      customers << new_customer
    end
    customers
  end
  # returns a collection of `Customer` instances, representing all of the Customer described in the CSV fil

  def self.find
    # uses Customer.all(id)
    # returns an instance of `Customer` where the value of the id field in the CSV matches the passed parameter
    # raise ArgumentError if ID does not exist
  end
end
