require "csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address
  @@new_customers = [] #will initialize when this file is called

  def initialize(id, email, address)
    @id = id #number
    @email = email #string
    @address = address #hash
    @@new_customers << self
  end

  def self.all
    # return a collection of Customer instances, representing
    # all of the customer described in sthe CSV file
    customer_data = []
    CSV.open("data/customers.csv", "r").each do |line|
      id = line[0].to_i
      #   puts id.class.to_i
      email = line[1]
      street = line[2]
      city = line[3]
      state = line[4]
      zipcode = line[5]
      address = {street: street,
                 city: city,
                 state: state,
                 zip: zipcode}
      customer_object = Customer.new(id, email, address)
      customer_data << customer_object
    end
    return customer_data
  end

  def self.find(id)
    # returns an instance of Customer where the
    # value of the id field in the CSV matches
    # the passed parameter
    customer_match = self.all.detect { |customer| customer.id == id }
    return customer_match
  end

  def self.save(filename)
    CSV.open(filename, "w") do |file|
      @@new_customers.each do |customer|
        file << [customer.id, customer.email, customer.address[:street], customer.address[:city], customer.address[:state], customer.address[:zip]]
      end
    end
  end
end

# Customer.new(123, "a@a.co", {
#   street: "123 Main",
#   city: "Seattle",
#   state: "WA",
#   zip: "98101",
# })

# Customer.new(521, "a@a.co", {
#   street: "123 Estornino Lane",
#   city: "Seattle",
#   state: "CA",
#   zip: "92021",
# })

# Customer.save("data/test.csv")
