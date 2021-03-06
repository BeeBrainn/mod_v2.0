class Order < ActiveRecord::Base
  attr_accessible :archive_flag, :details, :email, :name, :reserv_flag, :user_id
  has_many :line_items, dependent: :destroy
  belongs_to :user
  unless @current_user
  	self.validates :name, :email, presence: true
  end

  def add_line_items_from_cart(cart)
  	cart.line_items.each do |item|
  		item.cart_id = nil
  		line_items << item
  	end  	
  end
end
