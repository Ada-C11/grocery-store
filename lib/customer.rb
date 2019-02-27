
class Customer
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  attr_reader :id, :email, :address
  attr_writer :email, :address
end
