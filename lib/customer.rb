# customer.rb
require "csv"

# Create a class called Customer.
class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  # return collection of customer instances in a csv file
  def self.all
    customer_array = []

    CSV.read("data/customers.csv").each do |row|
      id = row[0].to_i
      email = row[1]
      address = {
        street: row[2],
        city: row[3],
        state: row[4],
        zip: row[5],
      }
      customer = Customer.new(id, email, address)
      customer_array << customer
    end

    return customer_array
  end

  # returns Customer instance that matches passed id parameter
  def self.find(customer_id)
    Customer.all.each do |customer|
      if customer.id == customer_id
        return customer
      end
    end

    return nil
  end
end
