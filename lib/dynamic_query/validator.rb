module DynamicQuery
  module Validator
    def filter_valid_info(query)
      output = {}
      
      query.each do |or_key, or_val|
        if or_key =~ /^or_\d+$/ && or_val.kind_of?(Hash)
          or_val.each do |and_key, and_val|
            if and_key =~ /^and_\d+$/ && and_val.kind_of?(Hash) &&
              (['column', 'operator', 'value1', 'value2'] - and_val.keys.map { |k| k.to_s }).empty?
               output[or_key] ||= {}; output[or_key][and_key] ||= {}
               output[or_key][and_key] = and_val
            end
          end
        end
      end
      
      output
    end
  end
end