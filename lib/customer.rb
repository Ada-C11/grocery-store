class Customer
  attr_reader :id
  attr_accessor :email, :address
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
end

# nara = Customer.new(213, "nara@gmail.com", {
#   street: "123 Main",
#   city: "Seattle",
#   state: "WA",
#   zip: "98101"
# })
