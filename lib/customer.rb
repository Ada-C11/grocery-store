require "csv"

class Customer
  attr_reader :cust_id
  attr_accessor :cust_email, :cust_address

  def initialize(cust_id, cust_email, cust_address)
    @cust_id = cust_id
    @cust_email = cust_email
    @cust_address = cust_address
  end

  def id
    return @cust_id
  end

  def email
    return @cust_email
  end

  def address
    return @cust_address
  end

  def self.all
    customers = []
    CSV.open("data/customers.csv", "r") do |file|
      file.each do |row|
        address = {}
        address[:street] = row[2]
        address[:city] = row[3]
        address[:state] = row[4]
        address[:zip] = row[5]
        customer = Customer.new(row[0].to_i, row[1], address)
        customers << customer
      end
    end
    return customers
  end

  def self.find(id)
    customers = self.all
    customers.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end

  def self.save(filename)
    customers = self.all
    CSV.open(filename, "w") do |file|
      customers.each do |customer|
        row = []
        row << customer.id.to_s
        row << customer.email
        row << customer.address[:street]
        row << customer.address[:city]
        row << customer.address[:state]
        row << customer.address[:zip]
        file << row
      end
    end
  end
end