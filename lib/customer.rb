require "csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    # returns a collection (array) of Customer instances, representing all of the Customer described in the CSV file
    return CSV.read("data/customers.csv").map do |customer_from_csv|
             customer = self.new(customer_from_csv[0].to_i, customer_from_csv[1],
                                 {
               street: customer_from_csv[2],
               city: customer_from_csv[3],
               state: customer_from_csv[4],
               zip: customer_from_csv[5],
             })
           end
  end

  def self.find(id)
    self.all.find { |customer| customer.id == id }
  end
end

# customer = Customer.new(123, "sophearychiv@gmail.com", { home: "210", st: "169th St" })
