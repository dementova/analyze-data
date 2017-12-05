require 'rails_helper'

RSpec.describe ChartManager do
	FILE = 'session_history.csv'

  it 'instance is class ChartManager' do
    chart = described_class.new FILE
    chart.should be_an_instance_of ChartManager
  end	

	context "class ChartManager's result" do
    let(:result) do
      described_class.generate FILE
    end

    it 'requires params' do
      expect{ described_class.generate }.to raise_error(ArgumentError)
    end

    it { expect(result.durations).to be_a(Hash) }

    it { expect(result.builds).to be_a(Hash) }

    it { expect(result.outliers).to be_a(Hash) }
	end

end