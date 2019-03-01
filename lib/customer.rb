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

  # create self method
  def self.all
    # iterate over each row of the csv
    customers = CSV.open('data/customers.csv','r').map do |field|
    Customer.new(field[0].to_i, "#{field[1]}", "#{field[2]}, #{field[3]}, #{field[4]}, #{field[5]}")
    end
    return customers
  end

  def self.find(id)
    total_customers = self.all
    total_customers.length.times do |i|
      if total_customers[i].id == id
        return total_customers[i]
      end
    end
    return nil
  end
end