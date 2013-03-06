module Match
  class Control < DbBase
    self.table_name = 'control'
    self.inheritance_column = 'ruby_type'
    
    attr_accessible :ID_BIRTHDAY, :ID, :ID_SEX, :AGE

  end
end