require "csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  # returns a collection of Customer instances, representing all of Customer info
  #return info from csv
  def self.all
    customer_info_array = CSV.open("data/customers.csv", "r").map do |customer|
      Customer.new(customer[0].to_i, "#{customer[1]}", "#{customer[2]}, #{customer[3]}, #{customer[4]}, #{customer[5]}")
    end
    return customer_info_array
  end

  # returns an instance of Customer where the value of the id field in the CSV matches the passed parameter
  def self.find(id)
    self.all.each do |search_customer|
      if search_customer.id == id
        return search_customer
      end
    end
    return nil
  end
end
