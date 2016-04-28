class AddListingIdToOrder < ActiveRecord::Migration
  def change
  	 def self.up
   add_column :orders, :listing_id, :string
 end

 def self.down
   remove_column :orders, :listing_id, :string
 end
  end
 
end
