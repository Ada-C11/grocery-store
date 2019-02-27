# class that creates an instance of a customer
class Customer

  # creates methods that will read or read/write certain instance variables
  attr_reader :id
  attr_accessor :email, :address

  # constructor that sets up each instance of a customer's id, email, and address
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  # method that returns all customer info in a hash
  def customer_details
    customer_hash = {
      id: @id,
      email: @email,
      address: @address,
    }
    return customer_hash
  end
end
