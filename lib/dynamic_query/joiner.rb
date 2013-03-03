module DynamicQuery
  module Joiner
    def join(records, keys)
      result = []
      li = find_logest_index(records)
      result << records[li]
      (1..li).to_a.reverse.each do |idx|
        ref_ary = records[idx - 1]
        new_ary = []
        result.first.each do |record|
          tgt_k = keys[idx * 2 - 1]
          ref_k = keys[idx * 2 - 2]
          new_ary << ref_ary.find { |r| ref_k.map { |rfk| r[rfk] } == tgt_k.map { |tfk| record[tfk] } }
        end
        result.unshift new_ary
      end if li != 0
      (li + 1..records.size - 1).each do |idx|
        ref_ary = records[idx]
        new_ary = []
        result.last.each do |record|
          if record.nil?
            new_ary << nil
            next
          end
          tgt_k = keys[idx * 2 - 2]
          ref_k = keys[idx * 2 - 1]
          new_ary << ref_ary.find { |r| ref_k.map { |rfk| r[rfk] } == tgt_k.map { |tfk| record[tfk] } }
        end
        result.unshift << new_ary
      end
      result.reduce(:zip).map! { |row| row.flatten }
    end
    
    private
    def find_logest_index(records)
      index = 0
      max = 0
      records.each_with_index do |r, idx|
        if r.size > max
          max = r.size
          index = idx
        end
      end
      index
    end
  end
end