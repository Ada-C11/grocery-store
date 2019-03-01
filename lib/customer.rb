require "customers.csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  # def self.all
  #   #returns a collection of Customer instances, representing all of Customer info
  #   result = "Customers:"
  #   @planets.each_with_index do |planet, index|
  #     result += "#{index + 1}. #{customer}\n"
  #   end
  #   return result
  # end

  # def self.find(id)
  #   #returns an instance of Customer where the value of
  #   #the id field in the CSV matches the passed parameter
  #     return @planets.find do |planet|
  #              planet.name.downcase == name.downcase
  #            end
  #   end
  # end
end
