class ReportsController < ApplicationController
  before_action :set_report, :set_attachment, only: [:show, :edit, :update, :destroy, :progress, :download]
	before_action :authenticate_user!, only: [:new, :edit, :index, :show, :destroy]

  def download
    send_data @attachment.file, filename: @attachment.name
  end

  # GET /reports
  # GET /reports.json
  def index
    # @reports = Report.all
    @search = Report.search(params[:q])
    @reports = @search.result.includes(:user, :attachments) # https://github.com/activerecord-hackery/ransack
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    report = Report.create(report_params)
    attachment = report.attachments.create(attachment_params)

    respond_to do |format|
      if report != nil && attachment != nil
        # format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.html { redirect_to action: 'index', notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params) && update_or_create_attachment
        @report.touch
        @attachment.touch
        # format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.html { redirect_to action: 'index', notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
        # redirect_to action: 'index'
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    def set_attachment
      # TODO: 複数ファイル対応
      @attachment = Attachment.find_by(report_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:title, :tag, :content, :user_id, :created_at, :updated_at)
    end

    def attachment_params
      params.require(:report).permit(:id, :attachment)
      file = params[:report][:attachment]
      attachment = {}
      if file != nil
        attachment[:file] = file.read
        attachment[:name] = file.original_filename
      end
      attachment[:report_id] = params[:id]
      return attachment
    end

    def update_or_create_attachment
      if @attachment != nil
        @attachment.update(attachment_params)
      elsif params[:report][:attachment] != nil
        @attachment = Attachment.new(attachment_params)
        return @attachment.save
      end
    end
end
