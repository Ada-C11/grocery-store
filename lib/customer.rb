require "csv"

class Customer
  attr_accessor :email, :address
  attr_reader :id

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    customer_array = []
    CSV.read("data/customers.csv").each do |row|
      address = {
        street: row[2],
        city: row[3],
        state: row[4],
        zip: row[5],
      }
      new_customer = Customer.new(row[0].to_i, row[1], address)
      customer_array << new_customer
    end
    return customer_array
  end

  def self.find(id)
    customer_array = Customer.all
    found_customer = customer_array.find do |customer|
      customer.id == id
    end
    return found_customer
  end

  def self.save(new_filename)
    customers = Customer.all
    CSV.open(new_filename, "w") do |line|
      customers.each do |cust|
        line << [cust.id, cust.email, cust.address[:street], cust.address[:city], cust.address[:state], cust.address[:zip]]
      end
    end
  end
end
