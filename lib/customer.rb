require 'csv'
require 'pry'
class Customer
  attr_reader :id
  attr_accessor :email, :address
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    all_customers = []
    CSV.read("data/customers.csv").each do |customer_from_csv|
      customer = Customer.new(customer_from_csv[0].to_i, customer_from_csv[1], { street: customer_from_csv[2], city: customer_from_csv[3], state: customer_from_csv[4], zip: customer_from_csv[5]})
      all_customers << customer
    end
    return all_customers
  end

  def self.find(id)
    all_customers = Customer.all
    customer = all_customers.find{|customer| customer.id == id}
    # raise ArgumentError.new("Customer id doesn't exist.") if customer.nil? 
    return customer 
  end
end


# Customer.all
# binding.pry
