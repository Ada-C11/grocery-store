
require 'csv'

class Customer
  attr_reader :id

  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  # opens the CSV and maps each row to a new array, adding a row at the top with the header rows as the instance variables
  def self.all
    customers = CSV.open("data/customers.csv",'r').map do |row|
      Customer.new(row[0].to_i, "#{row[1]}", "#{row[2]}, #{row[3]}, #{row[4]}, #{row[5]}")
    end
    return customers
  end

   # iterates over the array returned by self.all and compares the value at .id to the passed parameter
  def self.find(id)
    self.all.each do |search|
      if search.id == id
        return search
      end
    end
    return nil
  end

end

