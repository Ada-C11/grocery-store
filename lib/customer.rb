require "csv"
require "awesome_print"

class Customer
  attr_accessor :email, :address
  attr_reader :id

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    customer_data_array = []
    customer_data_collection = []
    CSV.open("../data/customers.csv", "r").each do |row|
      customer_data_array << row
    end

    customer_data_array.each do |customer|
      customer[2] = customer[2] + " " + customer[3] + " " + customer[4] + " " + customer[5]
      customer.slice!(3..5)
    end

    customer_data_array.each do |customer|
      customer_data_collection << Customer.new(customer[0].to_i, customer[1], customer[2])
    end

    return customer_data_collection
  end

  def self.find(id)
    Customer.all.find do |customer|
      customer.id == id
    end
  end
end
