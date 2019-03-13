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
    customers = []
    headers = ['id', 'email', 'address', 'city', 'state', 'zip code']
    CSV.foreach("data/customers.csv", :headers => headers).each do |row|
      address = "#{row['address']}, #{row['city']}, #{row['state']}, #{row['zip code']}"
      customer = Customer.new(row['id'].to_i, row['email'], address)
      customers << customer
    end
    return customers
  end

  def self.find(id)
    self.all.find{|customer| id == customer.id}
  end

end
