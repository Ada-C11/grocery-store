require 'awesome_print'
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
    #return array of all customers
    all_customers = []
    CSV.open('data/customers.csv', 'r').each do |line|
      id = line[0].to_i 
      email = line[1] 
      address = { street: line[2], city: line[3], state: line[4], zip: line[5] }
      customer = Customer.new(id, email, address)
      all_customers << customer
    end
    return all_customers
  end

  def self.find(search)
    not_found = nil
    Customer.all.each do |customer|
      binding.pry
      if customer.id == search
        return customer
      elsif customer.id = nil
        return not_found
      end
    end
  end
end

