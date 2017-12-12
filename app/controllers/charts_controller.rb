class ChartsController < ApplicationController
  FILE = 'session_history.csv'

  def index
    @result = ChartManager.generate FILE
  end
end
