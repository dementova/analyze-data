require 'csv'

class ChartManager
	attr_reader :durations, :builds, :outliers, :avr_duration

	def self.generate file
		new(file).define
	end

	def initialize file
		@file 			= file
    @durations 	= {}
    @builds 		= {}
    @outliers 	= {}
    @normal_durations = []
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
    	duration = row['duration'].to_f

			_set_duration_by_time( row['created_at'], duration )
			_set_status_by_date( date, row['summary_status'] )
			_set_duration_by_date( date, duration )
			_set_avr_normal_duration( duration, row['summary_status'] )
    end
	end

	def _build_outliers
		@avr_duration = @normal_durations.sum / @normal_durations.length
		@outliers.each do |date, durations|
			sum = durations.inject(0){|s, d| s += (d - avr_duration)**2; s }
			sigma = Math.sqrt( sum / durations.length )
			@outliers[date] = sigma.round(2)
		end
	end

	def _set_duration_by_time time_str, duration
		time = time_str.to_time.to_s(:db)
		@durations[time] = duration
	end

	def _set_status_by_date time, status
		@builds[time] ||= {}
		@builds[time][status] ||= 0
		@builds[time][status] += 1
	end

	def _set_duration_by_date time, duration
		@outliers[time] ||= []
		@outliers[time].push(duration)
	end

	def _set_avr_normal_duration duration, status
		@normal_durations.push( duration ) if status == 'passed'
	end

end