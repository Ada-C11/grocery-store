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
    CSV.read("data/customers.csv").each do |customer|
      id = customer[0].to_i
      email = customer[1]
      address = customer[2..5].join(", ")
      customers << Customer.new(id, email, address)
    end
    return customers
  end

  def self.find(id)
    customers = Customer.all
    customers.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end
end
