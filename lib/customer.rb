require 'csv'

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
    csv_customers = CSV.read('data/customers.csv')
    csv_customers.map do |customer| 
      @id = customer[0].to_i
      @email = customer[1]
      @address = {}
      @address[:street] = customer[2]
      @address[:city] = customer[3]
      @address[:state] = customer[4]
      @address[:zip_code] = customer[5]
      @customer = Customer.new(@id, @email, @address)
      customers << @customer
    end  
    return customers
  end

  def self.find(id)
    (self.all).find {|customer| customer.id == id}
  end

end

