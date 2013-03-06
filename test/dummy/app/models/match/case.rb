module Match
  class Case < DbBase
    self.table_name = 'case'
    self.inheritance_column = 'ruby_type'
    
    attr_accessible :ID_BIRTHDAY, :ID, :ID_SEX, :AGE

  end
end