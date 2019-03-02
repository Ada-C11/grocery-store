require 'csv'
require 'awesome_print'

class Customer
  attr_accessor :email, :address
  attr_reader :id

  CUSTOMER_ID_INDEX = 0
  EMAIL_INDEX = 1
  STREET_INDEX = 2
  CITY_INDEX = 3
  STATE_INDEX = 4
  ZIP_INDEX = 5
  CSV_FILE_PATH = "/Users/elisepham/Ada/grocery-store/data/customers.csv"

  def initialize(id, email, address)
    @id = id
    @address = address
    @email = email
  end

  def self.all
    customers = []
    CSV.open(CSV_FILE_PATH, 'r').each do |row|
      address = {
        :street => row[STREET_INDEX],
        :city => row[CITY_INDEX], 
        :state => row[STATE_INDEX], 
        :zip => row[ZIP_INDEX]
      }
      customer = Customer.new(row[CUSTOMER_ID_INDEX].to_i, row[EMAIL_INDEX], address)
      customers << customer
    end
    return customers
  end

  def self.find(id)
    customers = Customer.all
    customers.each do |customer|
      if customer.id == id
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