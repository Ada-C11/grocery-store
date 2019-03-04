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
    customers_all = []
    CSV.open("data/customers.csv", "r").each do |line|
      id = line[0].to_i
      email = line[1]
      address = {
        street: line[3],
        city: line[4],
        state: line[5],
        zip: line[6],
      }
      customers_all << self.new(id, email, address)
    end
    return customers_all
  end

  def self.find(id, customers = self.all)
    return customers.find(ifnone = nil) do |customer|
             customer.id == id
           end
  end
end
