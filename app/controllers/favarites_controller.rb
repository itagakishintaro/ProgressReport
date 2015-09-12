class FavaritesController < ApplicationController
  before_action :set_favarite, only: [:show, :edit, :update, :destroy]

  # GET /favarites
  # GET /favarites.json
  def index
    @favarites = Favarite.where(user_id: current_user.id).joins(:report)
  end

  # POST /favarites
  # POST /favarites.json
  def create
    @favarite = Favarite.new(favarite_params)

    respond_to do |format|
      if @favarite.save
        format.html { redirect_to @favarite, notice: 'Favarite was successfully created.' }
        format.json { render :show, status: :created, location: @favarite }
      else
        format.html { render :new }
        format.json { render json: @favarite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favarites/1
  # DELETE /favarites/1.json
  def destroy
    @favarite.destroy
    respond_to do |format|
      format.html { redirect_to favarites_url, notice: 'Favarite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favarite
      @favarite = Favarite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favarite_params
      params.require(:favarite).permit(:user_id, :report_id)
    end
end
