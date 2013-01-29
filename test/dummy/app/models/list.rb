class List < ActiveRecord::Base
  attr_accessible :name
  
  belongs_to :user
  has_many :entries, :dependent => :delete_all
  
  validates :name, :presence => true
end
