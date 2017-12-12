class Deviation
	attr_reader :deviation, :average

	def self.define data
		new(data).calculate
	end

	def initialize data
		@data = data
		@average = 0
	end

	def calculate
		_define_average
		_define_deviation
		self
	end

	private
	def _valid_data
		raise Error.new(:data_not_exists) unless @data.count.zero?
	end

	def _define_average
		@average = @data.sum / @data.count
	end

	def _define_deviation
		sum_x = @data.inject(0){|sum, x| sum += (x - @average)**2; sum }
		sigma = Math.sqrt( sum_x / @data.count ).round(2)
		@deviation = sigma
	end

end