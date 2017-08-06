require 'oj'

class FilterNestedHash
  attr_accessor :input_hash, :input_tag, :child_tag, :filter_tag, :role

  def initialize(input_hash, options = {})
    @input_hash = Oj.load(input_hash).with_indifferent_access
    @child_tag = options[:child_tag] || "children"
    @filter_tag = options[:filter_tag] || "privacy"
    @role = options[:role] || []
  end

  # Filter input_hash by check filter_tag and role contain in filter_tag, recursive check by child_tag
  def exec_filter
    filter(@input_hash)
  end

  private

  def filter(hash)
    hash.each do |k, v|
      if k == @filter_tag && v.is_a?(Array) && !v.empty?
        if @role.any? { |e| v.to_set.include?(e)}
          return hash
        else
          return nil
        end
      elsif k == @child_tag && v.is_a?(Array) && !v.empty?
        tmp = []
        v.each do |e|
          tmp_filter = filter(e)
          unless tmp_filter.nil?
            tmp.push(tmp_filter)
          end
        end
        hash[@child_tag] = tmp
      end
    end
    hash
  end
end
