class AdminUser < ActiveRecord::Base

  has_and_belongs_to_many :pages
  has_many :section_edits
  has_many :sections, :through => :section_edits

  #To configure a different table name
    #set_table_name("admin_users")
  
  #Don't need to configure each column because of ActiveRecord
    # attr_accessor :first_name
    #   
    #   def last_name 
    #     @last_name
    #   end
    #   
    #   def last_name=(value)
    #     @last_name = value
    #   end
    
    scope :named, lambda {|first,last| where(:first_name => first, :last_name => last)}
end
