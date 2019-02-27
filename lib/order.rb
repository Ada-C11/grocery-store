require_relative "customer"

class Order
  attr_reader :id
  attr_accessor :collection, :customer, :fulfillment_status

  def initialize(fulfillment_status: defualt)
    if ![:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError.new("#{fulfillment_status} not a valid fullfillment status")
    end
    @fulfillment_status = fulfillment_status
  end
end
