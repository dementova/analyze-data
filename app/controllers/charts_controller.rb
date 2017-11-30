class ChartsController < ApplicationController
  FILE = 'session_history.csv'

  def index
    @result = ChartManager.generate FILE
  end

  private
  def _file_params
  	params.require(:file).permit(:report)
  end
end
