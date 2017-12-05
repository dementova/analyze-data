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
    @normal_durations = []
    @average 		= 0
	end

	def define
		_valid_file
		_parse_file
		_define_average
		_define_deviation
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

	def _define_average
		@average = @normal_durations.sum / @normal_durations.count
	end

	def _define_deviation
		count = @normal_durations.count
		@outliers.each do |date, durations|
			sum_x = durations.inject(0){|sum, x| sum += (x - @average)**2; sum }
			sigma = Math.sqrt( sum_x / count )
			sigma = 3*sigma / count
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