require "csv"
require "awesome_print"

class Customer
  attr_accessor :email, :address, :id

  def initialize(id, email, address)
    @id = id.to_i
    @email = email
    @address = address
  end

  def self
  end

  # returns a collection of `Customer` instances, representing all of the Customer described in the CSV file
  def self.all
    customers_array = []
    CSV.open("data/customers.csv", "r").each do |line|
      customers_array << Customer.new(line[0].to_i, line[1], line[2])
    end

    return customers_array
  end

  # returns an instance of `Customer` where the value of the id field in the CSV matches the passed parameter
  def self.find(id)
    Customer.all.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end
end
