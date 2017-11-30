class Error < Exception

	DEFAULT_CODE = 0
	CODES = {
		file_not_exists: 1
	}
	
	def initialize type
		code = CODES[type.to_s.to_sym] || DEFAULT_CODE
		super I18n.t(:"exceptions._#{code}")
	end

end