require "csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  @@all_customers = []

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  CSV.read("/Users/karlaguadron/Documents/ada/03_week/grocery-store/data/customers.csv").each do |customer|
    @@all_customers << Customer.new(customer[0].to_i, customer[1], {street: customer[2], city: customer[3], state: customer[4], zip: customer[5]})
  end

  def self.all
    return @@all_customers
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

puts Customer.all.last