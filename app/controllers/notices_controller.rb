class NoticesController < ApplicationController
  def show
    @notice = Notice.find_by(user_id: params[:id])
    render :json => @notice.to_json
  end

  def upsert
    @notice = Notice.find_by(user_id: params[:user_id])
    if @notice == nil then
      Notice.create(notices_params)
      render :json => {status: :created}
    else
      logger.debug('------------')
      logger.debug(notices_params)
      @notice.update(notices_params)
      render :json => {status: :updated}
    end
  end

  private
    def notices_params
      params.permit(:user_id, :watched_at)
    end
end