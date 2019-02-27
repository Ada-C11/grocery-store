class Customer
  attr_accessor :email, :address
  attr_reader :id

  def initialize(id, email, delivery_address)
    @id = id
    @email = email
    @address = delivery_address
  end
end
