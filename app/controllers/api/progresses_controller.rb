module Api
  class ProgressesController < ApplicationController
    def index
      @progresses = Progress.includes(report: :user).all.map{ |d| {'user': d.report.user.name, 'point': d.point, 'time': d.updated_at} }
      respond_to do |format|
      	format.json { render :json => @progresses.to_json(:include => :report) }
      end
    end
  end
end