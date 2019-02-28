

class Customer
  attr_reader :cust_id
  attr_accessor :cust_email, :cust_address

  def initialize(cust_id, cust_email, cust_address)
    @cust_id = cust_id
    @cust_email = cust_email
    @cust_address = cust_address
  end

  def id
    return @cust_id
  end

  def email
    return @cust_email
  end

  def address
    return @cust_address
  end
end
