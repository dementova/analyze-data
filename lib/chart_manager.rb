require 'csv'

class ChartManager
	attr_reader :durations, :builds, :outliers

	def self.generate file
		new(file).define
	end

	def initialize file
		@file 			= file
    @durations 	= {}
    @builds 		= {}
    @outliers 	= {}
	end

	def define
		_valid_file
		_parse_file
		_build_outliers
		self
	end

	private
	def _valid_file
		raise Error.new(:file_not_exists) unless File.exists?(@file)
	end

	def _parse_file
    CSV.foreach(@file, headers: true) do |row|
    	date = row['created_at'].to_date

			_set_duration_by_time( row['created_at'], row['duration'] )
			_set_status_by_date( date, row['summary_status'] )
			_set_duration_by_date( date, row['duration'] )
    end
	end

	def _build_outliers
		@outliers.each do |date, durations|
			length = durations.length
			a = durations.sum/length
			sum = durations.inject(0){|s, d| s += (d - a)**2; s }
			sigma = Math.sqrt( sum/length )
			@outliers[date] = sigma.round(2)
		end
	end

	def _set_duration_by_time time_str, duration
		time = time_str.to_time.to_s(:db)
		@durations[time] = duration.to_f
	end

	def _set_status_by_date time, status
		@builds[time] ||= {}
		@builds[time][status] ||= 0
		@builds[time][status] += 1
	end

	def _set_duration_by_date time, duration
		@outliers[time] ||= []
		@outliers[time].push(duration.to_f)
	end

end