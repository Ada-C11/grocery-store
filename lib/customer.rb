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
      # change ID into integer, not string
      info[0] = info[0].to_i

      # customer_info_instance is an array, change to hash
      customer_info_instance = Customer.new(info[0], info[1], info[2])
      # customer_info_hash = {}
      # customer_info_hash["id"] = customer_info_instance[0].id
      # customer_info_hash["email"] = customer_info_instance[1].email
      # customer_info_hash["address"] = customer_info_instance[2].address

      # all_customer_info << customer_info_hash
      all_customer_info << customer_info_instance
    end

    return all_customer_info
  end

  def self.find(id)
    # # one array of all Customer instances. Each index holds one instance.
    all_info = Customer.all

    # # iterate through each customer
    all_info.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end
end

# practice = Customer.new(35, "angela@google.com", "134 flower lane")
