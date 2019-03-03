require "CSV"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    @customers_array = []
      CSV.read("data/customers.csv", "r").each do |info_line|
        id = info_line[0].to_i
        email = info_line[1]
        address = {
          street: info_line[2],
          city: info_line[3],
          state: info_line[4],
          zip: info_line[5],
        }
        customer = Customer.new(id, email, address)
    @customers_array << customer
      end
    return @customers_array
  end

  def self.find(id)
    Customer.all.find do |customer|
      customer.id == id
    end
  end
end