require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "Cart基本功能" do
    it "可以把商品丟到到Cart裡，然後Cart裡就有東西了" do
      cart = Cart.new
      cart.add_item 1
      expect(cart.empty?).to be false  
    end
    it "如果加了相同種類的商品到Cart裡，購買項目 （CartItem）並不會增加，但商品的數量會改變" do
      cart = Cart.new 
      3.times {cart.add_item(1)}
      4.times {cart.add_item(4)}
      expect(cart.items.length).to be 2
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.second.quantity).to be 4

    end
    it "商品可以放到Cart裡，也可以再拿出來" do
      cart = Cart.new
      p1 = Product.create(title:"太陽餅")
      p2 = Product.create(title:"鳳梨酥")
      3.times {cart.add_item(p1.id)}
      4.times {cart.add_item(p2.id)}
      expect(cart.items.first.product_id).to be p1.id
      expect(cart.items.second.product_id).to be p2.id
      expect(cart.items.first.product).to be_a Product  
    end

    it "可以計算Cart的總消費金額" do
      cart = Cart.new
      p1 = Product.create(title:"太陽餅", price: 90)
      p2 = Product.create(title:"鳳梨酥", price: 100)

      4.times {
       cart.add_item(p1.id)
       cart.add_item(p2.id) 
      }

      expect(cart.total_price).to be 760
    end
  end
  describe "Cart 進階功能" do
    it "可以Cart內容轉換成 Hash，存到 Session 裡" do
      cart = Cart.new
      3.times{cart.add_item(1)}
      4.times{cart.add_item(2)}

      expect(cart.serialize).to eq session_hash
    end

    it "可以把 Session （Hash 格式）的內容，還原成Cart的內容" do
      cart = Cart.from_hash(session_hash)
      expect(cart.items.first.product_id).to be 1
      expect(cart.items.first.quantity).to be 3 
      expect(cart.items.second.product_id).to be 2
      expect(cart.items.second.quantity).to be 4 
    end

  end
 def session_hash
    {
      "items" => [
        {"product_id" => 1, "quantity" => 3},
        {"product_id" => 2, "quantity" => 4}
      ]
    }
  end
end
