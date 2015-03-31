# http://kzy52.com/entry/2015/01/25/230006
class ApiController < ApplicationController
  def tags
    render json: Report.all
  end
end