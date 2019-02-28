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
    customer_array_csv = CSV.read("../data/customers.csv")

    array_of_customer_instance = []
    customer_array_csv.each do |customer|
      id = customer[0].to_i
      email = customer[1]
      address = {
        street: customer[2],
        city: customer[3],
        state: customer[4],
        zip: customer[5],
      }
      customer_instance = Customer.new(id, email, address)
      array_of_customer_instance << customer_instance
    end
    return array_of_customer_instance
  end

  def self.find(id_input)
    array_of_customer_instance = Customer.all
    last_id_number = array_of_customer_instance.length
    if id_input <= last_id_number && id_input >= 1
      return array_of_customer_instance[id_input - 1]
    else
      return nil
    end
  end
end

puts Customer.find (10)
