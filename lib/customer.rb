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
    customer_array = []
    CSV.open("data/customers.csv", "r").each do |line|
      customer_array << Customer.new(line[0].to_i, line[1], {street: line[2], city: line[3], state: line[4], zip: line[5]})
    end
    return customer_array
  end

  def self.find(id)
    Customer.all.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end
  
end
