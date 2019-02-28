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
        customer_array = []
        CSV.read("data/customers.csv", headers: true).each do |line|
            full_address = "#{line["address1"]}, #{line["city"]},  #{line["zipcode"]}"
            new_customer = self.new(line["id"].to_i, line["email"], full_address)
            customer_array.push(new_customer)
        end
        return customer_array
    end

    def self.find(id)
        customers = self.all
        found_customer = (customers.select{|customer| id == customer.id})[0]
        return found_customer
    end

end
