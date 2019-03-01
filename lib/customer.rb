require "csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address

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
    CSV.open("data/customers.csv", "r").each do |line|
      if line[0].to_i == id
        return Customer.new(line[0].to_i, line[1], line[2])
      end
    end
    return nil
  end
end
