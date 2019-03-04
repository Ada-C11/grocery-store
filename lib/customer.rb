require "csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    customers = []
    CSV.read("data/customers.csv").each do |row|
      customer_address = {street: row[2], city: row[3], state: row[4], zip: row[5]}
      customers.push(Customer.new(row[0].to_i, row[1], customer_address))
    end
    return customers
  end
end

Customer.all
