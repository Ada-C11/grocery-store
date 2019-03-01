class Customer
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def load_data(filename)
    # data = []
    # CSV.read('../data/customers.csv').each do |line|
    #   data << line.to_a
    # end
    # return data
  end  

  def self.all
    # returns a collection of Customer instances
    # representing every Customer described in the CSV file
    # return all_customers
  end

  def self.find(id)
  # if there is a match
    # returns an instance of Customer where the value of the id field
    # in the CSV matches the passed parameter
    # Invokes .all, and search it
    # return customer_with_matching_id
  # else return nil
  end
end
