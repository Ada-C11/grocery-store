require 'csv'
require 'awesome_print'

class Customer
  attr_accessor :email, :address
  attr_reader :id

  @@customer_id_index = 0
  @@email_index = 1
  @@street_index = 2
  @@city_index = 3
  @@state_index = 4
  @@zip_index = 5

  def initialize(id, email, address)
    @id = id
    @address = address
    @email = email
  end

  def self.all
    customers = []
    CSV.open("/Users/elisepham/Ada/grocery-store/data/customers.csv", 'r').each do |row|
      address = {
        :street => row[@@street_index],
        :city => row[@@city_index], 
        :state => row[@@state_index], 
        :zip => row[@@zip_index]
      }
      customer = Customer.new(row[@@customer_id_index].to_i, row[@@email_index], address)
      customers << customer
    end
    return customers
  end

  def self.find(look_up_value)
    customers = Customer.all
    customers.each do |customer|
      if customer.id == look_up_value
          return customer
      end
    end
    return nil
  end

  def self.save(file_name)
    customers = all
    CSV.open(file_name, "wb") do |csv|
      customers.each do |customer|
        csv << ["#{customer.id}","#{customer.email}","#{customer.address[:street]}",
        "#{customer.address[:city]}","#{customer.address[:state]}","#{customer.address[:zip]}"]
      end
    end
  end
end

# Customer.save("../data/customers_wave3.csv")