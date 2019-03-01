class Customer 
    
    attr_reader :id
    attr_accessor :email, :del_address

    def initialize(id, email, del_address)
        @id = id
        @email = email
        @del_address = del_address
    end 
end
