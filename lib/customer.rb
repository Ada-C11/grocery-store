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
      customer = Customer.new(row["customer_id"].to_i, row["email"], {
        street: row["address1"],
        city: row["city"],
        state: row["state"],
        zip: row["zip"],
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
end

# Customer.find(9)
