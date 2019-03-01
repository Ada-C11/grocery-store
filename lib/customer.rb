require "csv"

class Customer
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  attr_reader :id

  attr_accessor :email, :address

  def self.all
    customer_csv = CSV.read("data/customers.csv", headers: true)

    all_customers = []

    customer_csv.each do |row|
      customer = Customer.new(row[0].to_i, row[1], {
        street: row[2],
        city: row[3],
        state: row[4],
        zip: row[5],
      })

      all_customers << customer
    end

    return all_customers
  end

  def self.find(id)
    customers = Customer.all
    check = true
    customers.each do |c|
      if c.id == id
        return c
      else
        check = false
      end
    end
    if check == false
      return nil
    end
  end

  def self.save(filename)
    customers = Customer.all
    CSV.open(filename, "w") do |file|
      header_row = ["id", "email", "address1", "city", "state", "zip"]
      file << header_row
      customers.each do |c|
        new_line = ["#{c.id}", "#{c.email}", "#{c.address[:street]}", "#{c.address[:city]}", "#{c.address[:state]}", "#{c.address[:zip]}"]
        file << new_line
      end
    end
  end
end

Customer.save("new_customers.csv")
