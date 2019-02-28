class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end


end

#making sure Customer class works as expected
# tatiana = Customer.new(1001)

# tatiana.email = "tat@g.com"

# tatiana.delivery_address = { address: "404 Kendon St, Seattle WA 98110" }

# # puts tatiana.delivery_address