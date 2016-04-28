class AddPhoneNoToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :phone_no, :string
  end
end
