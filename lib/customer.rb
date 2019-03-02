require "csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  @@all_customers = []

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    CSV.read("/Users/karlaguadron/Documents/ada/03_week/grocery-store/data/customers.csv").each do |customer|
      @@all_customers << Customer.new(customer[0].to_i, customer[1], {street: customer[2], city: customer[3], state: customer[4], zip: customer[5]})
    end
    return @@all_customers
  end

  def self.find(id)
    Customer.all.each do |customer|
      return customer if customer.id == id
    end
    return nil
  end

  def self.save(file_name)
    customer_list = Customer.all
    CSV.open(file_name, "w") do |line|
      customer_list.each do |customer|
        indiv_customer = [customer.id.to_s, customer.email, customer.address[:street], customer.address[:city], customer.address[:state], customer.address[:zip]]
        line << indiv_customer
      end
    end
  end
end
