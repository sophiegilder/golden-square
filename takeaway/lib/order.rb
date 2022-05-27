require "rubygems"
require "twilio-ruby"
$LOAD_PATH << File.dirname(__FILE__)
require "customer.rb"
require "menu.rb"
require "dish.rb"
require "api_config.rb"
require "confirmation_text.rb"
require "receipt.rb"

class Order
  def initialize(customer, menu, text) # takes a Customer and Menu object
    @customer = customer
    @menu = menu
    @text = text
    @basket = []
  end

  def basket
    @basket
  end

  def customer
    @customer
  end

  def text
    @text
  end

  def menu
    @menu
  end

  def add(dish, qty) # takes a dish object
    fail dish_not_available if !menu.all.include?(dish)
    fail dish_not_available if dish.quantity < 1
    fail "There are only #{dish.quantity} #{dish.name} in stock" if dish.quantity < qty
    if basket.any? { |item| item[:dish] == dish }
      basket.each { |item| item[:qty] += qty if item[:dish] == dish}
    else
      basket << {dish: dish, qty: qty}
    end
    dish.quantity -= qty
  end

  def remove(dish, qty)
    fail "Item not in basket" if basket.all? { |h| h[:dish] != dish }
    basket.each do |item|
      item[:qty] -= qty if item[:dish] == dish # reduces the quantity in the basket
    end
    dish.quantity += qty # adds the quantity back to the Dish object
    basket.delete_if {|h| h[:qty] < 1} # if the quantity of the item in the basket is now 0, remove it
  end

  def cancel
    basket.each do |item|
      item[:dish].quantity += item[:qty]
    end
    @basket = []
  end

  def confirm
    text.send
    return "Confirmation text sent to customer"
  end

  private
  def dish_not_available
    "Dish not currently available"
  end
end


# customer = Customer.new("Sophie", "Waterbeach", ENV['MY_NUMBER'])
# menu = Menu.new(Kernel)
# dish_1 = Dish.new("cake", 12, 5)
# dish_2 = Dish.new("Loaded fries", 6, 5)
# menu.add(dish_1)
# menu.add(dish_2)
# api = ApiConfig.new
# text = ConfirmationText.new(customer, api)
# order = Order.new(customer, menu, text)
# order.add(dish_1, 2)
# order.add(dish_2, 1)
# # order.confirm
# binding.irb
# bill = Receipt.new(Kernel, order)
# bill.itemised_bill_formatted