# require_relative "order"

class Customer
  #   attr_reader :id # why is this par not working
  attr_accessor :email, :address

  def initialize(id, email, address)
    @ID = id
    @email = email
    @address = address
  end

  def id # I have to have this reader because the helper doesn't work
    return @ID
  end

  def summary
    return "#{@ID} --- #{@email} --- #{@address}"
  end
end
