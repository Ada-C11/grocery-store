require 'csv'
require 'awesome_print'

class Customer
    attr_reader :id
    attr_accessor :email, :address

    def initialize(id, email, address)
        @id = id.to_i
        @email = email
        @address = address
    end

    # accessing information from CSV to return collection of Customer instances
    def self.all
        new_customer = []
        CSV.open('data/customers.csv', 'r').each do |line|
            new_customer << Customer.new(line[0], line[1], {street: line[2], city: line[3], state: line[4], zip: line[5]})
        end
        return new_customer
    end

    # pull all the customer information, look for ID, match?
    def self.find(id)
        Customer.all.each do |new_customer|
            if new_customer.id == id
                return new_customer
            end 
        end
        return nil
    end
end

# new_customer = Customer.new(id, email, address)
# ap Customer.find('12')