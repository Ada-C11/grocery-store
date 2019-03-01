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
    customer_info = []
    CSV.open("data/customers.csv", "r").each do |customer|
      id = customer[0].to_i
      email = customer[1].to_s
      address = {
        address: customer[2].to_s,
        city: customer[3].to_s,
        state: customer[4].to_s,
        zipcode: customer[5].to_s,
      }
      customer_info << Customer.new(id, email, address)
    end
    return customer_info
  end

  def self.find(id)
    all_customer_info = Customer.all
    return id > all_customer_info.length ? nil : all_customer_info[id - 1]
  end
end
