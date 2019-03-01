require 'csv'
require 'awesome_print'
# Customer contains init, processes a CSV into an array, and has a find method
class Customer
  attr_accessor(:email, :address, :id)
  # Contains methods pertaining to customers
  def initialize(id, email, address)
    @address = address
    @email = email
    @id = id
  end

  # reads CSV of customer data into array of arrays
  def self.all
    customers = []
    CSV.foreach('data/customers.csv') do |r|
      new_customer = Customer.new(r[0].to_i, r[1], %i[street city state zip].zip(r.slice(2..5)).to_h)
      customers << new_customer
    end
    customers
  end

  # finds and returns customer with passed id (or nil if no record has passed id)
  def self.find(id)
    all_customers = Customer.all
    customer = all_customers.detect { |record| record.id == id }
    customer
  end
end
