class ProgressesController < ApplicationController
  # POST /progresses
  # POST /progresses.json
  def create
    @progress = Progress.new(progress_params)
    @progress.save
    redirect_to :back
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def progress_params
      params.require(:progress).permit(:point, :report_id, :user_id, :created_at, :updated_at)
    end
end
