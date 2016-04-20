class AddPersonIdToOrders < ActiveRecord::Migration
  def change
  	 def self.up
   add_column :orders, :persons_id, :string
 end

 def self.down
   remove_column :orders, :persons_id, :string
 end
  end
end
