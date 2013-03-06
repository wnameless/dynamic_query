module Match
  class R201Oo2009 < DbBase
    self.table_name = 'r201_oo2009'
    self.inheritance_column = 'ruby_type'
    
    attr_accessible :FEE_YM, :APPL_TYPE, :HOSP_ID, :APPL_DATE, :CASE_TYPE, :SEQ_NO, :ORDER_TYPE, :DRUG_NO, :DRUG_USE, :DRUG_FRE, :UNIT_PRICE, :TOTAL_QTY, :TOTAL_AMT, :ORDER_SEQ_NO

  end
end