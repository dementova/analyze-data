require 'rails_helper'

RSpec.describe Deviation do

  let(:data){ _set_data }

  it 'instance is class Deviation' do
    deviation = described_class.new data
    deviation.should be_an_instance_of Deviation
  end	

  it 'requires params' do
    expect{ described_class.define }.to raise_error(ArgumentError)
  end

	context "class Deviation's result" do
    let(:result){ described_class.define data }
    let(:average){ _define_average }
    let(:deviation){ _define_deviation }

    it{ expect(result.average).to eq(average) }
    it{ expect(result.deviation).to eq(deviation) }
  end

  def _set_data
  	[444.0, 531.0, 554.0, 575.0, 539.0, 393.0, 391.0, 433.0, 897]
  end

  def _define_average
  	data.sum / data.count
  end

  def _define_deviation
		sum_x = data.inject(0){|sum, x| sum += (x - average)**2; sum }
		Math.sqrt( sum_x / data.count ).round(2)  	
  end

end