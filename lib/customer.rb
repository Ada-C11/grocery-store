class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def customer_info
    customer = { id: @id, email: @email, address: @address }
    return customer
  end
end
