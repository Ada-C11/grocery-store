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

  def self.save(file_name)
    customers = Customer.all
    CSV.open(file_name, "w") do |csv|
      customers.each do |customer|
        customer_address = customer.address.split(", ")
        csv << [customer.id, customer.email, customer_address[0], customer_address[1], customer_address[2], customer_address[3]]
      end
    end
  end
end
