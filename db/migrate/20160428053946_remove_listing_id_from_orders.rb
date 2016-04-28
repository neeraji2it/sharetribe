class RemoveListingIdFromOrders < ActiveRecord::Migration
  def change
  	 remove_column :orders, :listing_id, :string
  end
end
