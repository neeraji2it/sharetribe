class CommunityCategory < ActiveRecord::Base
  belongs_to :community
  belongs_to :category
  belongs_to :share_type
end

class ShareType < ActiveRecord::Base
    
  has_many :sub_share_types, :class_name => "ShareType", :foreign_key => "parent_id"
  # children is a more generic alias for sub share_types, used in classification.rb
  has_many :children, :class_name => "ShareType", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "ShareType"
  has_many :community_categories
  has_many :communities, :through => :community_categories
  has_many :listings
  has_many :translations, :class_name => "ShareTypeTranslation", :dependent => :destroy 

  
end

class FixPriceQuantityPlaceholders < ActiveRecord::Migration


  
end
