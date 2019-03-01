# require_relative "order"
require "csv"
# require_relative "../data/customers"

class Customer
  attr_accessor :email, :address
  attr_reader :id

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    @customers = []
    CSV.open("data/customers.csv", "r").each do |line|
      id = line[0]
      email = line[1]
      # I WAS WORKING HERE LAST
      address = {"street-address" => line[2],
                 "city" => line[3],
                 "state" => line[4],
                 "zip-code" => line[5]}
      @customers << Customer.new(id.to_i, email, address)
    end
    return @customers
    #returns a collection of customer instances (representing info for each cutomer from csv file)
  end

  def self.find(id)
    customers = Customer.all
    customers.find do |customer|
      if customer.id == id.to_i
        return customer
      end
    end
    #   # returns instance of customer that corresponds to the id given as a parameter
    #   # invoke Customer.all to find the matching id
  end
end
