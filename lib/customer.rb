require "csv"

class Customer
  attr_accessor :email, :address
  attr_reader :id

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    customer_array = []
    CSV.read("data/customers.csv").each do |row|
      new_customer = Customer.new(row[0].to_i, row[1], row[2..-1].join(", "))
      customer_array << new_customer
    end
    return customer_array
  end

  def self.find(id)
    customer_array = Customer.all
    found_customer = customer_array.find do |customer|
      customer.id == id
    end
    return found_customer
  end
end
