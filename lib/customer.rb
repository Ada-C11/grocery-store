class Customer
  attr_accessor(:email, :address, :id)
  # Contains methods pertaining to customers
  def initialize(id, email, address)
    @address = address
    @email = email
    @id = id
  end
end
