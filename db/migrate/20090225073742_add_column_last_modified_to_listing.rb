class AddColumnLastModifiedToListing < ActiveRecord::Migration
  def self.up
    add_column :listings, :lastmodified, :datetime
    
  end

  def self.down
    remove_column :listings, :lastmodified, :datetime
    
  end
end
