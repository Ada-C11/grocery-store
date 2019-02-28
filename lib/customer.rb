# create customer class
require 'csv'

class Customer
  # add writer for email and address, add reader for id
  attr_accessor :email, :address
  attr_reader :id
  # initialize class with id, email and address as instance variables
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    CSV.open('customer.csv','r').each do |customer|
      customers = []
      customers << self.csv_customer(customer)
    end
    return customers
  end

  def self.find(id)
    
  end
end