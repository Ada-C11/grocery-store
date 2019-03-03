require "csv"
require "awesome_print"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    customers, line_arr = [], []
    # Create a new instance of Customer with each line
    CSV.read("data/customers.csv").each do |line|
      line_arr = line.to_a
      customer = Customer.new(line_arr[0].to_i, line_arr[1], {
        :address1 => line_arr[2],
        :city => line_arr[3],
        :state => line_arr[4],
        :zipcode => line_arr[5],
      })
      customers << customer
    end
    return customers
  end

  def self.find(id)
    customers = self.all
    matching_customer = customers.select { |customer| id == customer.id }[0]
    return matching_customer
  end

  def self.save(filename)
    line = 0
    customers = self.all
    CSV.open(filename, "w") do |file|
      customers.each do |customer|
        line = [customer.id.to_s, customer.email, customer.address[:address1], customer.address[:city], customer.address[:state], customer.address[:zipcode]]
        file << line
      end
    end
  end
end