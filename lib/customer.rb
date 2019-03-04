require "csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  # collects data into a customer
  def customer_info
    customer = { id: @id, email: @email, address: @address }
    return customer
  end

  # collects all customers from csv file
  def self.all
    customers = []

    CSV.open("data/customers.csv", "r").each do |customer_info|
      customer_address = { street: customer_info[2],
                          city: customer_info[3],
                          state: customer_info[4],
                          zip: customer_info[5] }
      new_customer = Customer.new(customer_info[0].to_i, customer_info[1], customer_address)
      customers << new_customer
    end
    return customers
  end

  # finds specfic customer
  def self.find(id)
    Customer.all.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end
end
