# require "awesome_print"
# require_relative '../data/csv_practice'
require "csv"

# class that creates an instance of a customer
class Customer

  # creates methods that will allow reading or reading/writing of specified instance variables
  attr_reader :id
  attr_accessor :email, :address

  # constructor that sets up each instance of a customer's id, email, and address
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  # method that returns all customer info in a hash
  def customer_details
    customer_hash = {
      id: @id,
      email: @email,
      address: @address,
    }
    return customer_hash
  end

  # method that returns an array of all customer instances using data pulled from the customers.csv file
  def self.all
    all_customers = []

    CSV.open("data/customers.csv", "r").each do |line|
      address = {}
      address[:steet] = line[2]
      address[:city] = line[3]
      address[:state] = line[4]
      address[:zip] = line[5]

      all_customers << Customer.new(line[0].to_i, line[1], address)
    end
    return all_customers
  end

  # returns an instance of Customer where the value of the id field in the CSV matches the passed parameter
  def self.find(id)
    return Customer.all.find { |customer| id == customer.id }

    #   if found_customer == nil
    #     raise ArgumentError, "Customer ID numer does not exist!"
    #   else
    #     return found_customer
    #   end
  end
  #   found_customer = nil

  #   Customer.all.each do |customer|
  #     found_customer = customer if customer.id == id
  #   end
  #   return found_customer
  # end
end
