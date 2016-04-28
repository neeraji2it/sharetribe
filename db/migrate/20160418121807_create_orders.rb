class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
       
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :cardtype
      t.string :cardno
      t.string :username
      
      t.timestamps null: false
    end
  end
end
