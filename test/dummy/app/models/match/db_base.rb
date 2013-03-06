module Match
  class DbBase < ActiveRecord::Base
    establish_connection :adapter => "mysql2", :database => "match", :host => "127.0.0.1", :user => "root", :password => nil
    self.table_name = 'r201_oo2009'
  end
end