require "awesome_print"
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
    CSV.open("data/customers.csv", "r").each do |instance|
      instance

      id = instance[0].to_i
      email = instance[1]
      street_address = instance[2]
      city = instance[3]
      state = instance[4]
      zip = instance[5]

      address = { street: street_address,
                  city: city,
                  state: state,
                  zip: zip }

      instance_customer = Customer.new(id, email, address)

      customers << instance_customer
    end
    return customers
  end

  def self.find(id)
    self.all.each do |customer|
      if customer.id == id
        puts customer
        return customer
      end
    end
    return nil
  end
end

# puts Customer.new
