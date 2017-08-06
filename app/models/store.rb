class Store
  attr_accessor :db, :local

  def initialize(hash = {})
    @db = (hash[:db] || {}).with_indifferent_access
    @local = (hash[:local] || {}).with_indifferent_access
  end

  def get_value_by(element)
    case element[:type]
    when 'db'
      if @db[element[:table]].is_a?(Hash)
        @db[element[:table]][element[:column]][:value]
      end
    when 'local'
      @local[:local][element[:name]]
    else
      element[:value]
    end
  end

  def processing_list(hash)
    total = nil
    hash[:elements].each do |e|
      if total.nil?
        total = e[:value]
      else
        case hash[:operator]
        when '+'
          total = total + Util::convert_to_same_type_by(total, get_value_by(e))
        when '-'
          total = total - Util::convert_to_same_type_by(total, get_value_by(e))
        when '*'
          total = total - Util::convert_to_same_type_by(total, get_value_by(e))
        when '/'
          total = total - Util::convert_to_same_type_by(total, get_value_by(e))
        end
      end
    end
    total
  end
end
