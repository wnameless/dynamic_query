class Entry < ActiveRecord::Base
  attr_accessible :deadline, :description, :priority, :title
  
  belongs_to :list
  
  validates :title, :presence => true
  validates :priority, :presence => true
  validates :priority, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 4 }
end
