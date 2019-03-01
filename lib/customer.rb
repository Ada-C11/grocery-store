class Customer
  attr_reader :id
  attr_accessor :email_address, :delivery_address

  def initialize(id, email_address, delivery_add)
    @id = id
    @email_address = email_address
    @delivery_add = delivery_add
  end
end
