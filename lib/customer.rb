require "csv"
require "awesome_print"
# require_relative '../data/customers.csv'

class Customer
  attr_accessor :email, :address
  attr_reader :id

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    customers = [] # this is an array of instances of the Customer

    CSV.open("data/customers.csv", "r").each do |customer_row|
      customers << Customer.new(customer_row[0].to_i, customer_row[1], {street: customer_row[2], city: customer_row[3], state: customer_row[4], zipcode: customer_row[5]})
    end

    return customers
  end

  def self.find(id)
    self.all.each do |customer|
      if customer.id == id
        return customer # an instance of Customer where the value of the id field in the CSV matches the passed parameter
      end
    end
    return nil # <-- Exit the loop. If the id wasn't found by the if statement, return nil.
  end
end
