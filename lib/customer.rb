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
    all_customer_info = []
    CSV.open("/Users/angelaoh/documents/grocery-store/data/customers.csv", "r").each do |info|
      info[0] = info[0].to_i

      customer_info_instance = Customer.new(info[0], info[1], info[2])
      all_customer_info << customer_info_instance
    end

    return all_customer_info
  end

  def self.find(id)
    all_info = Customer.all
    all_info.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end
end
