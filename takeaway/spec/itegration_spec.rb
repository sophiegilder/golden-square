require "dish"
require "menu"
require "customer"
require "order"
require "receipt"

RSpec.describe "integration" do

  it "adds dishes to the menu and returns the list" do
    terminal = double :terminal
    menu = Menu.new(terminal)
    dish_1 = Dish.new("Ch*cken burger", 12, 20)
    dish_2 = Dish.new("Loaded fries", 6, 50)
    dish_3 = Dish.new("Chocolate m*lkshake", 4, 80)
    menu.add(dish_1)
    menu.add(dish_2)
    menu.add(dish_3)
    expect(menu.all).to eq [dish_1, dish_2, dish_3]
  end

  xit "adds dishes to the menu and are puts out in a nice format" do
    menu = Menu.new(terminal)
    dish_1 = Dish.new("Ch*cken burger", 12, 20)
    dish_2 = Dish.new("Loaded fries", 6, 50)
    dish_3 = Dish.new("Chocolate m*lkshake", 4, 80)
    menu.add(dish_1)
    menu.add(dish_2)
    menu.add(dish_3)
    expect(terminal).to receive(:puts)
    .with("Ch*cken burger - £12\nLoaded frieds - £6\nChocolate m*lkshake - £4")
    menu.view_all
  end

  xit "doesn't puts dish to console if it is out of stock" do
    menu = Menu.new(terminal)
    dish_1 = Dish.new("Ch*cken burger", 12, 0)
    dish_2 = Dish.new("Loaded fries", 6, 50)
    dish_3 = Dish.new("Chocolate m*lkshake", 4, 80)
    menu.add(dish_1)
    menu.add(dish_2)
    menu.add(dish_3)
    expect(terminal).to receive(:puts)
    .with("Loaded frieds - £6\nChocolate m*lkshake - £4")
    menu.view_all
  end

  xit "returns an error if all dishes are out of stock" do
    menu = Menu.new(terminal)
    dish_1 = Dish.new("Ch*cken burger", 12, 0)
    dish_2 = Dish.new("Loaded fries", 6, 0)
    dish_3 = Dish.new("Chocolate m*lkshake", 4, 0)
    menu.add(dish_1)
    menu.add(dish_2)
    menu.add(dish_3)
    expect(menu).to receive(:puts)
    .with("Restaurant out of stock!")
    menu.view_all
  end

  xit "adds an dish to the Order basket" do
    customer = Customer.new("Sophie", "Waterbeach", "+447557942369")
    menu = Menu.new(terminal)
    dish_1 = Dish.new("Ch*cken burger", 12, 5)
    dish_2 = Dish.new("Loaded fries", 6, 5)
    menu.add(dish_1)
    menu.add(dish_2)
    order = Order.new(customer, menu)
    order.add(dish_1, 2)
    order.add(dish_2, 1)
    expect(order.basket).to eq [{dish: dish_1, qty: 2}, {dish: dish_2, qty: 1}]
    expect (dish_1.quantity).to eq 3
    expect (dish_2.quantity).to eq 4
  end


  xit "can't add item to Order basket if it's not added to the menu" do
    customer = Customer.new("Sophie", "Waterbeach", "+447557942369")
    menu = Menu.new(terminal)
    dish_1 = Dish.new("Ch*cken burger", 12, 5)
    dish_2 = Dish.new("Loaded fries", 6, 5) # create dish, but don't add it to menu
    menu.add(dish_1)
    order = Order.new(customer, menu)
    expect { order.add(dish_2) }.to raise_error "Dish not currently available"
  end

  xit "can't add dish to Order basket if it's out of stock" do
    customer = Customer.new("Sophie", "Waterbeach", "+447557942369")
    menu = Menu.new(terminal)
    dish_1 = Dish.new("Ch*cken burger", 12, 5)
    dish_2 = Dish.new("Loaded fries", 6, 0) # out of stock
    menu.add(dish_1)
    menu.add(dish_2)
    order = Order.new(customer, menu)
    expect { order.add(dish_2, 2) }.to raise_error "Dish not currently available"
  end

  xit "raises error if customer tries to add too many of an item" do
    customer = Customer.new("Sophie", "Waterbeach", "+447557942369")
    menu = Menu.new(terminal)
    dish_1 = Dish.new("Ch*cken burger", 12, 5)
    dish_2 = Dish.new("Loaded fries", 6, 5) # out of stock
    menu.add(dish_1)
    menu.add(dish_2)
    order = Order.new(customer, menu)
    expect { order.add(dish_2, 6) }.to raise_error "There are only 6 Loaded fries in stock"
  end

  xit "Removes a quantity of dishes from the order basket" do
    customer = Customer.new("Sophie", "Waterbeach", "+447557942369")
    menu = Menu.new(terminal)
    dish_1 = Dish.new("Ch*cken burger", 12, 5)
    dish_2 = Dish.new("Loaded fries", 6, 5)
    menu.add(dish_1)
    menu.add(dish_2)
    order = Order.new(customer, menu)
    order.add(dish_1, 2)
    order.add(dish_2, 1)
    order.remove(dish_1, 1)
    order.remove(dish_2, 1)
    expect(order.basket).to eq [{dish: dish_1, qty: 1}]
    expect (dish_1.quantity).to eq 4
    expect (dish_2.quantity).to eq 5
  end

  xit "empties basket and resets quantities" do
    customer = Customer.new("Sophie", "Waterbeach", "+447557942369")
    menu = Menu.new(terminal)
    dish_1 = Dish.new("Ch*cken burger", 12, 5)
    dish_2 = Dish.new("Loaded fries", 6, 5)
    menu.add(dish_1)
    menu.add(dish_2)
    order = Order.new(customer, menu)
    order.add(dish_1, 2)
    order.add(dish_2, 1)
    order.cancel
    expect(order.basket).to eq []
    expect (dish_1.quantity).to eq 5
    expect (dish_2.quantity).to eq 5
  end

  # Possible edge cases...
  # Item can't be removed because it's not in the basket
  # basket is already empty and can't be emptied

  xit "Receipt takes order and putses it in a nice format" do
    dish_1 = Dish.new("Ch*cken burger", 12, 5)
    dish_2 = Dish.new("Loaded fries", 6, 5)
    customer = Customer.new("Sophie", "Waterbeach", "+447557942369")
    menu = Menu.new(terminal)
    menu.add(dish_1)
    menu.add(dish_2)
    order = Order.new(customer, menu)
    order.add(dish_1, 2)
    order.add(dish_2, 1)
    receipt = Receipt.new(terminal, order)
    expect(terminal).to receive(:puts)
    .with("Receipt\nCh*cken burger (£12) x 2\nLoaded frieds (£6) x 1")
    expect(terminal).to receive(:puts)
    .with("Grand total: £30")
    receipt.itemised_bill_formatted
  end

  # Possible edge cases...
  # Order is empty

end