class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def _safe_action
  	@result ||= { error: false, error_msg: '' }
  	begin
  		yield
  	rescue Exception => e
      @result[:error] = true
      @result[:error_msg] = e.message

      if request.format.json?
        render json: @result.to_json
      else
        @result
      end
  	end

  end

end
