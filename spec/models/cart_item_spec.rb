require 'rails_helper'

RSpec.describe CartItem, type: :model do
  it "每個 Cart Item 都可以計算它自己的金額（小計）" do
    
    p1 = Product.create(title:"太陽餅", price: 90)
    p2 = Product.create(title:"鳳梨酥", price: 100)
    
    cart = Cart.new
    3.times {cart.add_item(p1.id)}
    4.times {cart.add_item(p2.id)}

    expect(cart.items.first.price).to be 270
    expect(cart.items.second.price).to be 400
  end
end