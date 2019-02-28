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

    customer_csv.each do |array|
      customer = Customer.new(array[0].to_i, array[1], {
        street: array[2],
        city: array[3],
        state: array[4],
        zip: array[5],
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
