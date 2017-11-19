class ChartsController < ApplicationController
  def generate
  	_safe_action do
	  	data = _file_params
	  	@result = ChartManager.generate data[:report]		
	  	render :json => @result.to_json
  	end
  end

  private
  def _file_params
  	params.require(:file).permit(:report)
  end
end
