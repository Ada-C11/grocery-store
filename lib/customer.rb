require "csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  # Returns an array of customer objects
  def self.all
    all_customers = []
    CSV.open("data/customers.csv").each do |row|
      row_id = row[0].to_i
      row_email = row[1]
      row_address = { street: row[2],
                     city: row[3],
                     state: row[4],
                     zip: row[5] }
      all_customers << Customer.new(row_id, row_email, row_address)
    end
    return all_customers
  end

  # Returns a Customer object with matching ID. If no matches are found, returns nil.
  def self.find(id)
    return (self.all).find { |customer| customer.id == id }
  end

  # creates a file identical to the original csv at the specified filepath
  def self.save(filepath)
    CSV.open(filepath, "w") do |newfile|
      CSV.open("data/customers.csv").each do |row|
        newfile << row
      end
    end
  end
end
