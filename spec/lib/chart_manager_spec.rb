require 'rails_helper'

RSpec.describe ChartManager do
	FILE = 'test.csv'

  it 'instance is class ChartManager' do
    chart = described_class.new FILE
    chart.should be_an_instance_of ChartManager
  end	

  it 'requires params' do
    expect{ described_class.generate }.to raise_error(ArgumentError)
  end

  context "class ChartManager's result" do
    let(:result){ described_class.generate FILE }

    before(:all) do 
      @durations  = {}
      @builds     = {}
      @tests      = {}

      _parse_file
      
      @deviation = {
        by_duration: _set_deviation_date( @durations ),
        by_test: _set_deviation_date( @tests )
      }
    end

    it { expect(result.durations).to eq(@durations) }
    it { expect(result.builds).to eq(@builds) }
    it do
      [:by_duration, :by_test].each do |key|
        expect(result.deviations[key]).to eq(@deviation[key])
      end
    end
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

  def _parse_file
    CSV.foreach(FILE, headers: true) do |row|
      date = row['created_at'].to_date
      time = row['created_at'].to_time.to_s(:db)
      duration = row['duration'].to_f

      _set_duration_by_time( time, duration )
      _set_tests_by_time( time, row['passed_tests_count'] )
      _set_status_by_date( date, row['summary_status'] )
    end
  end

  def _set_duration_by_time  time, duration
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