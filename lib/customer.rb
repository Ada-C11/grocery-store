require "csv"
require "awesome_print"

class Customer
  attr_reader :email, :address, :id

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
      id = line[0].to_i
      email = line[1]
      street = line[2]
      city = line[3]
      state = line[4]
      zip = line[5]
      address = {
        :street => street,
        :city => city,
        :state => state,
        :zip => zip,
      }
      customers_array << Customer.new(id, email, address)
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
