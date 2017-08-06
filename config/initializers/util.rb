module Util
	def self.convert_to_same_type_by item, item_need_convert
		case item
		when String
			item_need_convert.to_s
		when Fixnum
			item_need_convert.to_i
		when Float
			item_need_convert.to_f
		else
			item_need_convert
		end
	end
end
