require "csv"

def combine_address(hash)
  return "#{hash["street"]}, #{hash["city"]}, #{hash["state"]}, #{hash["zip"]}"
end

class Customer
  attr_reader :id, :email, :address
  attr_writer :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    @array_of_customers = []
    CSV.open("data/customers.csv", headers: true).each do |customer|
      id = customer["id"].to_i
      email = customer["email"]
      address = combine_address(customer)
      @array_of_customers.push(self.new(id, email, address))
    end
    return @array_of_customers
  end

  def self.find(id)
    found_customer = self.all.find do |customer|
      customer.id == id
    end
    return found_customer
  end
end
