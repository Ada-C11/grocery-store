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
        CSV.read("data/customers.csv").each do |line|
            full_address = "#{line[2]}, #{line[3]}, #{line[4]} #{line[5]}"
            new_customer = self.new(line[0].to_i, line[1], full_address)
            customer_array.push(new_customer)
        end
        return customer_array
    end

    def self.find(id)
        customers = self.all
        found_customer = (customers.select{|customer| id == customer.id})[0]
        return found_customer
    end

    def self.save(filename)
        customers = self.all

        CSV.open(filename, "w") do |file|
            customers.each do |customer|
                file << customer
            end
        end
    end

end

