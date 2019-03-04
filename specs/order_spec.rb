require "minitest/autorun"
require "minitest/reporters"
require "minitest/skip_dsl"

require_relative "../lib/customer"
require_relative "../lib/order"
require "csv"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

describe "Order Wave 1" do
  let(:customer) do
    address = {
      street: "123 Main",
      city: "Seattle",
      state: "WA",
      zip: "98101",
    }
    Customer.new(123, "a@a.co", address)
  end

  describe "#initialize" do
    it "Takes an ID, collection of products, customer, and fulfillment_status" do
      id = 1337
      fulfillment_status = :shipped
      order = Order.new(id, {}, customer, fulfillment_status)

      expect(order).must_respond_to :id
      expect(order.id).must_equal id

      expect(order).must_respond_to :products
      expect(order.products.length).must_equal 0

      expect(order).must_respond_to :customer
      expect(order.customer).must_equal customer

      expect(order).must_respond_to :fulfillment_status
      expect(order.fulfillment_status).must_equal fulfillment_status
    end

    it "Accepts all legal statuses" do
      valid_statuses = %i[pending paid processing shipped complete]

      valid_statuses.each do |fulfillment_status|
        order = Order.new(1, {}, customer, fulfillment_status)
        expect(order.fulfillment_status).must_equal fulfillment_status
      end
    end

    it "Uses pending if no fulfillment_status is supplied" do
      order = Order.new(1, {}, customer)
      expect(order.fulfillment_status).must_equal :pending
    end

    it "Raises an ArgumentError for bogus statuses" do
      bogus_statuses = [3, :bogus, "pending", nil]
      bogus_statuses.each do |fulfillment_status|
        expect {
          Order.new(1, {}, customer, fulfillment_status)
        }.must_raise ArgumentError
      end
    end
  end

  describe "#total" do
    it "Returns the total from the collection of products" do
      products = {"banana" => 1.99, "cracker" => 3.00}
      order = Order.new(1337, products, customer)

      expected_total = 5.36

      expect(order.total).must_equal expected_total
    end

    it "Returns a total of zero if there are no products" do
      order = Order.new(1337, {}, customer)

      expect(order.total).must_equal 0
    end
  end

  describe "#add_product" do
    it "Increases the number of products" do
      products = {"banana" => 1.99, "cracker" => 3.00}
      before_count = products.count
      order = Order.new(1337, products, customer)

      order.add_product("salad", 4.25)

      puts order.products
      expected_count = before_count + 1
      expect(order.products.count).must_equal expected_count
    end

    it "Is added to the collection of products" do
      products = {"banana" => 1.99, "cracker" => 3.00}
      order = Order.new(1337, products, customer)

      order.add_product("sandwich", 4.25)
      expect(order.products.include?("sandwich")).must_equal true
    end

    it "Raises an ArgumentError if the product is already present" do
      products = {"banana" => 1.99, "cracker" => 3.00}

      order = Order.new(1337, products, customer)
      before_total = order.total

      expect {
        order.add_product("banana", 4.25)
      }.must_raise ArgumentError

      # The list of products should not have been modified
      expect(order.total).must_equal before_total
    end
  end
end

# TODO: change 'xdescribe' to 'describe' to run these tests
describe "Order Wave 2" do
  describe "Order.all" do
    it "Returns an array of all orders" do
      # TODO: Your test code here!
      orders = Order.all
      expect(orders.length).must_equal 100
      orders.each do |o|
        expect(o).must_be_kind_of Order
      end
    end

    it "Returns accurate information about the first order" do
      first = Order.all.first

      # Check that all data was loaded as expected
      expect(first.id).must_equal 1
    end

    it "Returns accurate information about the last order" do
      # TODO: Your test code here!
      last = Order.all.last

      # Check that all data was loaded as expected
      expect(last.id).must_equal 100
    end
  end

  describe "Order.find" do
    it "Can find the first order from the CSV" do
      # TODO: Your test code here!
      first = Order.find(1)

      expect(first).must_be_kind_of Order
      expect(first.id).must_equal 1
    end

    it "Can find the last order from the CSV" do
      # TODO: Your test code here!

      last = Order.find(100) #100,Amaranth:83.81;Smoked Trout:70.6;Cheddar:5.63,20,pending

      expect(last).must_be_kind_of Order
      expect(last.id).must_equal 100
    end

    it "Returns nil for an order that doesn't exist" do
      # TODO: Your test code here!
      expect(Order.find(34326)).must_be_nil
    end
  end

  describe "Order.remove_product" do
    it "remove the product from the order" do
      order = Order.find(39) #order: 39,Beans:78.89;Mangosteens:35.01,31,paid

      expect(order.products.length).must_equal 2

      expect { order.remove_product("Tofu") }.must_raise ArgumentError
      expect(order.products.length).must_equal 2

      order.remove_product("Beans")
      expect(order.products.length).must_equal 1
    end
  end

  describe "Find orders by customer's id" do
    it "find orders with the same customer's id" do
      customer_orders = Order.find_by_customer(33) #53,Vegetable Stock:32.51,33,complete | 49,Bay Leaves:51.02;Sea Salt:56.44;Macadamia Nut:73.3,33,complete
      first_customer_order = customer_orders[0]
      expect(customer_orders.length).must_equal 4
      expect(first_customer_order.id).must_equal 49
    end
  end
end
