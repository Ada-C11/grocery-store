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

    CSV.read("data/customers.csv", "r").each do |customer_line|
      id = customer_line[0].to_i
      email = customer_line[1]
      address = {
                  street: customer_line[2],
                  city: customer_line[3],
                  state: customer_line[4],
                  zip: customer_line[5],
                }
      instance_customer = Customer.new(id, email, address)
      customer_array << instance_customer
    end
    return customer_array
  end

  def self.find(id)
    customer_array = Customer.all
    customer_array.each do |customer|
      if customer.id == id
        return customer
      else
        return nil
      end
    end
  end
end
