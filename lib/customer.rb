#attr_accessor is a shortcut for when you need both attr_reader and attr_writer.

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initalize(id, email, address)
    @id = id
    @email = email
    @delivery_address = address
  end
end
