require "csv"
require_relative "order.rb"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id_num, email_address, delivery_address)
    @id = id_num
    @email = email_address
    @address = delivery_address
  end

  def self.all
    customer_array = []
    CSV.open("data/customers.csv", "r").each do |row|
      id = row[0].to_i
      email = row[1]
      address = {
        street: row[2],
        city: row[3],
        state: row[4],
        zip: row[5],
      }
      customer_array << Customer.new(id, email, address)
    end
    return customer_array
  end

  def self.find(id)
    Customer.all.detect { |customer| customer.id == id }
    # returns an instance of Customer where the value of the id field in the CSV matches the passed parameter
  end
end
