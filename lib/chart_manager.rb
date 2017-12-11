require 'csv'

class ChartManager
	attr_reader :durations, :builds, :deviations

	def self.generate file
		new(file).define
	end

	def initialize file
		@file 			= file
    @durations 	= {}
    @builds 		= {}
    @deviations	= {}
    @tests 			= {}
	end

	def define
		_valid_file
		_parse_file
		_define_deviation_by_duration
		_define_deviation_by_tests
		self
	end

	private
	def _valid_file
		raise Error.new(:file_not_exists) unless File.exists?(@file)
	end

	def _parse_file
    CSV.foreach(@file, headers: true) do |row|
    	date = row['created_at'].to_date
			time = row['created_at'].to_time.to_s(:db)
    	duration = row['duration'].to_f

			_set_duration_by_time( time, duration )
			_set_tests_by_time( time, row['passed_tests_count'] )
			_set_status_by_date( date, row['summary_status'] )
    end
	end

	def _define_deviation_by_duration
		@deviations[:by_duration] = _set_deviation_date( @durations )
	end

	def _define_deviation_by_tests
		@deviations[:by_test] = _set_deviation_date( @tests )
	end

	def _set_deviation_date data
		date = [] 
		res = Deviation.define( data.values )
		data.each do |t, d| 
			if ( d - res.average ).abs > res.deviation
				date.push( t.to_date )
			end
		end
		date
	end

	def _set_duration_by_time time, duration
		@durations[time] = duration
	end

	def _set_tests_by_time time, tests
		@tests[time] = tests.to_i
	end

	def _set_status_by_date time, status
		@builds[time] ||= {}
		@builds[time][status] ||= 0
		@builds[time][status] += 1
	end

end