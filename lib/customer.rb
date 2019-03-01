require "csv"

class Customer
  attr_accessor :email, :address
  attr_reader :id

  def initialize(id, email, delivery_address)
    @id = id
    @email = email
    @address = delivery_address
  end

  def self.all
    customers = []
    file = CSV.open("data/customers.csv", "r")

    file.each do |line|
      id = line[0].to_i
      email = line[1]
      delivery_address = {street: line[2], city: line[3], state: line[4], zip: line[5]}

      customer = Customer.new(id, email, delivery_address)
      customers << customer
    end
    return customers
  end

  def self.find(id_number)
    Customer.all.find do |customer|
      customer.id == id_number
    end
  end
end
